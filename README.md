# Foundry Smart Contract Lottery (Raffle)

A decentralized, automated lottery (raffle) smart contract system built with [Foundry](https://book.getfoundry.sh/) and Chainlink VRF/Automation.  
Inspired by the [Cyfrin Updraft](https://github.com/Cyfrin/updraft) course and the teachings of [Patrick Collins](https://twitter.com/patrickalphac).

---

## 🚀 Project Overview

This project implements a secure, automated lottery (raffle) contract using:
- **Chainlink VRF v2.5** for provable randomness
- **Chainlink Automation** for automated winner selection
- **Foundry** for development, testing, and scripting

It includes:
- A robust `Raffle.sol` contract
- Full integration and unit tests
- Deployment and interaction scripts
- Mock contracts for local testing

---

## 📋 Requirements

- [Foundry](https://book.getfoundry.sh/getting-started/installation) (`forge`, `cast`)
- [Node.js](https://nodejs.org/) (for npm scripts, if used)
- [Git](https://git-scm.com/)
- (Optional) [Anvil](https://book.getfoundry.sh/anvil/) for local chain

**Install Foundry:**
```sh
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

---

## 🛠️ Setup

1. **Clone the repo:**
   ```sh
   git clone https://github.com/yourusername/foundry-smart-contract-lottery.git
   cd foundry-smart-contract-lottery
   ```

2. **Install dependencies:**
   ```sh
   forge install
   ```

3. **Run tests:**
   ```sh
   forge test -vv
   ```

4. **Check coverage:**
   ```sh
   forge coverage --report lcov --match-path 'src/**' --match-path 'script/**'
   ```

---

## 📦 Project Structure

- `src/` - Main contracts (`Raffle.sol`)
- `script/` - Deployment and interaction scripts
- `test/` - Unit and integration tests
- `lib/` - External dependencies (Chainlink, etc.)
- `test/mocks/` - Mock contracts for local testing

---

## 📝 Shoutouts

- **Cyfrin Updraft**: This project was built following the [Cyfrin Updraft](https://github.com/Cyfrin/updraft) course.
- **Patrick Collins**: Big thanks to [Patrick Collins](https://twitter.com/patrickalphac) for his educational content and guidance in smart contract development.

---

## 📖 Usage

- Deploy locally or to testnets using the scripts in `script/`.
- Run all tests with `forge test`.
- Check coverage as shown above.
- Customize the raffle parameters in `Raffle.sol` or via deployment scripts.

---

## 🛡️ Security

- Uses Chainlink VRF for secure randomness.
- Uses Chainlink Automation for trustless execution.
- Includes extensive tests and mocks for local development.

---

## 📬 Feedback & Contributions

PRs and issues are welcome!  
If you use this as a template or learning resource, please give a shoutout to Cyfrin and Patrick Collins.

---

**Happy Building! 🚀**