// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract SnakeGame is Ownable, ReentrancyGuard {

    // ── Events ────────────────────────────────────────────────────────────────
    event ScoreSubmitted(address indexed player, uint256 score, uint256 points);
    event BattleCreated(uint256 indexed battleId, address challenger, address opponent, uint256 stake);
    event BattleCompleted(uint256 indexed battleId, address winner, uint256 prize);
    event PointsAwarded(address indexed player, uint256 points, string reason);

    // ── Structs ───────────────────────────────────────────────────────────────
    struct PlayerStats {
        uint256 highScore;
        uint256 totalPoints;
        uint256 gamesPlayed;
        uint256 lastPlayed;
        uint256 streak;
        bool exists;
    }

    struct Battle {
        address challenger;
        address opponent;
        uint256 stake;        // in points
        uint256 challengerScore;
        uint256 opponentScore;
        uint8 status;         // 0=pending, 1=active, 2=completed, 3=cancelled
        string mode;          // realtime, turns, async
        uint256 createdAt;
    }

    // ── State ─────────────────────────────────────────────────────────────────
    mapping(address => PlayerStats) public players;
    mapping(uint256 => Battle) public battles;
    address[] public playerList;
    uint256 public battleCount;
    uint256 public totalPlayers;

    // ── Constructor ───────────────────────────────────────────────────────────
    constructor() Ownable(msg.sender) {}

    // ── Player registration ───────────────────────────────────────────────────
    function registerPlayer() external {
        if (!players[msg.sender].exists) {
            players[msg.sender].exists = true;
            players[msg.sender].totalPoints = 50; // Welcome bonus
            playerList.push(msg.sender);
            totalPlayers++;
            emit PointsAwarded(msg.sender, 50, "Welcome bonus");
        }
    }

    // ── Submit score ──────────────────────────────────────────────────────────
    function submitScore(uint256 score) external {
        require(score > 0, "Score must be positive");
        require(score <= 10000, "Score too high"); // anti-cheat

        PlayerStats storage p = players[msg.sender];
        if (!p.exists) {
            p.exists = true;
            playerList.push(msg.sender);
            totalPlayers++;
        }

        // Calculate points from score
        uint256 pts = (score / 10) * 10;

        // Milestone bonuses
        if (score >= 50)  pts += 100;
        if (score >= 100) pts += 300;
        if (score >= 200) pts += 1000;
        if (score >= 500) pts += 5000;

        // Update high score
        if (score > p.highScore) p.highScore = score;

        p.totalPoints += pts;
        p.gamesPlayed++;
        p.lastPlayed = block.timestamp;

        // Daily streak
        if (block.timestamp - p.lastPlayed < 48 hours) {
            p.streak++;
            if (p.streak == 7)  pts += 200;
            if (p.streak == 30) pts += 1000;
        } else {
            p.streak = 1;
        }

        emit ScoreSubmitted(msg.sender, score, pts);
        emit PointsAwarded(msg.sender, pts, "Game score");
    }

    // ── Battle ────────────────────────────────────────────────────────────────
    function createBattle(address opponent, uint256 stake, string calldata mode) external returns (uint256) {
        require(opponent != msg.sender, "Cannot battle yourself");
        require(opponent != address(0), "Invalid opponent");
        require(stake >= 100, "Min stake 100 pts");
        require(players[msg.sender].totalPoints >= stake, "Insufficient points");

        players[msg.sender].totalPoints -= stake;

        uint256 battleId = battleCount++;
        battles[battleId] = Battle({
            challenger: msg.sender,
            opponent: opponent,
            stake: stake,
            challengerScore: 0,
            opponentScore: 0,
            status: 0,
            mode: mode,
            createdAt: block.timestamp
        });

        emit BattleCreated(battleId, msg.sender, opponent, stake);
        return battleId;
    }

    function acceptBattle(uint256 battleId) external {
        Battle storage b = battles[battleId];
        require(b.opponent == msg.sender, "Not your battle");
        require(b.status == 0, "Battle not pending");
        require(players[msg.sender].totalPoints >= b.stake, "Insufficient points");

        players[msg.sender].totalPoints -= b.stake;
        b.status = 1; // active
    }

    function submitBattleScore(uint256 battleId, uint256 score) external {
        Battle storage b = battles[battleId];
        require(b.status == 1, "Battle not active");
        require(msg.sender == b.challenger || msg.sender == b.opponent, "Not in battle");
        require(score <= 10000, "Score too high");

        if (msg.sender == b.challenger) {
            b.challengerScore = score;
        } else {
            b.opponentScore = score;
        }

        // Both submitted — resolve
        if (b.challengerScore > 0 && b.opponentScore > 0) {
            _resolveBattle(battleId);
        }
    }

    function _resolveBattle(uint256 battleId) internal {
        Battle storage b = battles[battleId];
        b.status = 2;

        uint256 prize = b.stake * 2;
        address winner;

        if (b.challengerScore >= b.opponentScore) {
            winner = b.challenger;
        } else {
            winner = b.opponent;
        }

        players[winner].totalPoints += prize;
        emit BattleCompleted(battleId, winner, prize);
        emit PointsAwarded(winner, prize, "Battle victory");
    }

    function cancelBattle(uint256 battleId) external {
        Battle storage b = battles[battleId];
        require(b.challenger == msg.sender, "Not challenger");
        require(b.status == 0, "Cannot cancel");
        b.status = 3;
        players[msg.sender].totalPoints += b.stake; // refund
    }

    // ── Owner: award points manually ──────────────────────────────────────────
    function awardPoints(address player, uint256 points, string calldata reason) external onlyOwner {
        if (!players[player].exists) {
            players[player].exists = true;
            playerList.push(player);
            totalPlayers++;
        }
        players[player].totalPoints += points;
        emit PointsAwarded(player, points, reason);
    }

    // ── Views ─────────────────────────────────────────────────────────────────
    function getPlayer(address player) external view returns (PlayerStats memory) {
        return players[player];
    }

    function getLeaderboard(uint256 limit) external view returns (address[] memory addrs, uint256[] memory scores) {
        uint256 len = playerList.length < limit ? playerList.length : limit;
        addrs = new address[](len);
        scores = new uint256[](len);

        // Simple sort (top N)
        address[] memory temp = playerList;
        for (uint256 i = 0; i < len; i++) {
            uint256 maxIdx = i;
            for (uint256 j = i+1; j < temp.length; j++) {
                if (players[temp[j]].totalPoints > players[temp[maxIdx]].totalPoints) {
                    maxIdx = j;
                }
            }
            (temp[i], temp[maxIdx]) = (temp[maxIdx], temp[i]);
            addrs[i] = temp[i];
            scores[i] = players[temp[i]].totalPoints;
        }
    }

    function getBattle(uint256 battleId) external view returns (Battle memory) {
        return battles[battleId];
    }
}
