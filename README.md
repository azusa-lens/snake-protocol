# 🐍 SNAKE — Web3 Snake Game on Base

> The most addictive Web3 snake game on Base. Play with your face as the snake head. Battle friends. Earn $SNAKE airdrop.

[![Live Game](https://img.shields.io/badge/Play%20Now-snake--protocol.vercel.app-39FF14?style=flat-square)](https://snake-protocol.vercel.app)
[![Base Mainnet](https://img.shields.io/badge/Base-Mainnet-0052FF?style=flat-square)](https://basescan.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)

---

## What is SNAKE?

SNAKE is a Web3-native snake game built exclusively on Base L2. It combines the timeless addictiveness of classic Snake with Web3 mechanics — wallet-linked scores, on-chain battle mode, and a community $SNAKE token airdrop.

**What makes it different:**
- 🎭 Upload your photo → your face becomes the snake head
- ⚔️ Battle friends — stake points, highest score wins
- 🔊 Full sound effects — eat, die, milestone fanfare
- 📤 Auto-generate shareable Twitter posts after every game
- 🪙 Earn $SNAKE airdrop just by playing

---

## Features

| Feature | Status |
|---|---|
| Classic snake gameplay | ✅ Live |
| Realistic grass field graphics | ✅ Live |
| Upload photo as snake head | ✅ Live |
| Sound effects | ✅ Live |
| Wallet connect (MetaMask) | ✅ Live |
| Points system + leaderboard | ✅ Live |
| Daily challenges | ✅ Live |
| Referral system | ✅ Live |
| Auto share post to Twitter | ✅ Live |
| Battle mode (Live/Turns/Async) | ✅ Live |
| On-chain score submission | ✅ Live |
| $SNAKE token launch | 🔜 Coming soon |
| NFT snake skins | 🔜 Phase 2 |
| Staking | 🔜 Phase 2 |
| Mobile app | 🔜 Phase 2 |

---

## Live Contract

| Network | Contract | Status |
|---|---|---|
| Base Mainnet | Coming soon | 🔜 Deploying |
| Base Sepolia | Coming soon | 🔜 Testnet |

---

## Points System

| Action | Points |
|---|---|
| Eat food | +10 pts |
| Eat bonus star ⭐ | +50 pts |
| Score milestone 50 | +100 pts |
| Score milestone 100 | +300 pts |
| Score milestone 200 | +1,000 pts |
| Score milestone 500 | +5,000 pts |
| Daily login | +25 pts |
| 7-day streak | +200 pts |
| 30-day streak | +1,000 pts |
| Daily challenge | +500 pts |
| Refer a friend | +200 pts |
| Win a battle | +Stake pts |

**Levels:** Rookie → Player → Gamer → Shark → Legend

---

## Battle Mode

Challenge any wallet address to a snake battle. Stake points. Highest score wins the pot.

**Three modes:**
- ⚡ **Live** — play simultaneously in real time
- 🔄 **Turns** — take turns, compare scores
- 📅 **Async** — challenge someone, they play later

When you create a battle, SNAKE automatically generates a Twitter post with your challenge link — making it viral by default.

---

## $SNAKE Token

> **$SNAKE token is coming soon — could go live at any time.**

**Total supply: 1,000,000,000 — fixed forever. No inflation.**

| Allocation | % | Purpose |
|---|---|---|
| Community airdrop | 40% | Players ranked by points at snapshot |
| Gameplay rewards | 30% | Ongoing in-game reward pool |
| Team | 15% | 1-year cliff, 2-year vesting |
| DEX liquidity | 15% | Uniswap V3 on Base |

Points snapshot taken before token launch. More points = larger $SNAKE allocation.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Blockchain | Base L2 (Ethereum) |
| Smart contract | Solidity 0.8.20 + OpenZeppelin |
| Dev tooling | Hardhat v2 |
| Frontend | Vanilla HTML/CSS/JS |
| Leaderboard | Google Sheets API |
| Hosting | Vercel |

---

## Project Structure

```
snake-protocol/
├── contracts/
│   └── SnakeGame.sol      ← On-chain scores, battles, points
├── scripts/
│   └── deploy.js          ← Deploy script
├── index.html             ← Full game UI
├── hardhat.config.js
├── .env.example
└── README.md
```

---

## Local Development

```bash
# Clone
git clone https://github.com/azusa-lens/snake-protocol.git
cd snake-protocol

# Install
npm install --legacy-peer-deps

# Configure
cp .env.example .env
# Add your PRIVATE_KEY

# Compile
npx hardhat compile

# Deploy testnet
npx hardhat run scripts/deploy.js --network base_sepolia

# Deploy mainnet
npx hardhat run scripts/deploy.js --network base
```

---

## Roadmap

### Phase 1 — Live ✅
- Game live on Base
- Photo head upload
- Sound effects
- Battle mode (all 3 types)
- Points + leaderboard
- Auto share posts
- Referral system

### Phase 2 — Coming Soon 🔜
- $SNAKE token launch
- Community airdrop
- On-chain leaderboard
- NFT snake skins

### Phase 3 — Future 🎯
- Staking $SNAKE for rewards
- Seasonal tournaments
- Mobile app
- Partner integrations

---

## Contributing

MIT license — fork, build, contribute.

1. Fork the repo
2. Create branch: `git checkout -b feature/your-feature`
3. Commit and push
4. Open a Pull Request

---

## Links

| | |
|---|---|
| 🎮 Play | [snake-protocol.vercel.app](https://snake-protocol.vercel.app) |
| 🐦 Twitter | [@SnakeBaseGame](https://twitter.com/SnakeBaseGame) |
| 💻 GitHub | [github.com/azusa-lens/snake-protocol](https://github.com/azusa-lens/snake-protocol) |

---

## License

MIT — free to use, fork, and deploy.

Built with ❤️ on Base 🔵
