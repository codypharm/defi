// // SPDX-License-Identifier: MIT

// pragma solidity ^0.8.20;

// import {Test} from "forge-std/Test.sol";
// import {DeployDSC} from "../../script/DeployDSC.s.sol";
// import {DecentralizedStableCoin} from "../../src/DecentralizedStableCoin.sol";
// import {DSCEngine} from "../../src/DSCEngine.sol";
// import {HelperConfig} from "../../script/HelperConfig.s.sol";
// import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

// contract DSCEngineTest is Test {
//     DeployDSC deployer;
//     DecentralizedStableCoin dsc;
//     DSCEngine dsce;
//     HelperConfig public helperConfig;
//     address ethUsdPriceFeed;
//     address btcUsdPriceFeed;
//     address weth;

//     address public USER = makeAddr("user");
//     uint256 public constant AMOUNT_COLLATERAL = 10 ether;
//     uint256 public constant STARTING_USER_BALANCE = 10 ether;

//     function setUp() public {
//         deployer = new DeployDSC();
//         (dsc, dsce, helperConfig) = deployer.run();
//         (ethUsdPriceFeed, btcUsdPriceFeed, weth,,) = helperConfig.activeNetworkConfig();

//         ERC20Mock(weth).mint(USER, STARTING_USER_BALANCE);
//         // ERC20Mock(wbtc).mint(USER, STARTING_USER_BALANCE);
//     }

//     ////////////////////////////////////
//     ///// Constructor Tests ////////////
//     ///////////////////////////////////
//     address[] public tokenAddresses;
//     address[] public priceFeedAddresses;

//     function testRevertsIftokenLengthDoesntMathchPriceFeeds() public {
//         tokenAddresses.push(weth);
//         priceFeedAddresses.push(ethUsdPriceFeed);
//         priceFeedAddresses.push(btcUsdPriceFeed);

//         vm.expectRevert(DSCEngine.DSCEngine__TokenAddressesAndPriceFeedAddressesMustBeSameLength.selector);
//         new DSCEngine(tokenAddresses, priceFeedAddresses, address(dsc));
//     }

//     ///////////////////////////////
//     ///// Price Tests ////////////
//     //////////////////////////////
//     function testGetUsdValue() public view {
//         uint256 ethAmount = 15e18;
//         //15e18 * 2000/ETH = 30,000e18
//         uint256 expectedUsd = 30000e18;
//         uint256 actualUsd = dsce.getUsdValue(weth, ethAmount);
//         assertEq(expectedUsd, actualUsd);
//     }

//     function testGetTokenAmountFromUsd() public view {
//         // If we want $100 of WETH @ $2000/WETH, that would be 0.05 WETH
//         uint256 expectedWeth = 0.05 ether;
//         uint256 amountWeth = dsce.getTokenAmountFromUsd(weth, 100 ether);
//         assertEq(amountWeth, expectedWeth);
//     }

//     //////////////////////////////////////////
//     ///// depositCollateral Tests ////////////
//     /////////////////////////////////////////

//     function testRevertIfCollateralZero() public {
//         vm.prank(USER);
//         ERC20Mock(weth).approve(address(dsce), AMOUNT_COLLATERAL);

//         vm.expectRevert(DSCEngine.DSCEngine__NeedsMoreThanZero.selector);
//         dsce.depositCollateral(weth, 0);
//     }

//     function testRevertsWithUnapprovedCollateral() public {
//         ERC20Mock randToken = new ERC20Mock();
//         vm.startPrank(USER);
//         vm.expectRevert(DSCEngine.DSCEngine__NotAllowedToken.selector);
//         dsce.depositCollateral(address(randToken), AMOUNT_COLLATERAL);
//         vm.stopPrank();
//     }

//     modifier depositCollateral() {
//         vm.startPrank(USER);
//         ERC20Mock(weth).approve(address(dsce), AMOUNT_COLLATERAL);
//         dsce.depositCollateral(weth, AMOUNT_COLLATERAL);
//         vm.stopPrank();
//         _;
//     }

//     function testCanDepositCollateralAndGetAccountInfo() public depositCollateral {
//         (uint256 totalDscMinted, uint256 collateralValueInUsd) = dsce.getAccountInformation(USER);

//         uint256 expectedTotalDscMinted = 0;
//         uint256 expectedDepositAmount = dsce.getTokenAmountFromUsd(weth, collateralValueInUsd);

//         assertEq(totalDscMinted, expectedTotalDscMinted);
//         assertEq(AMOUNT_COLLATERAL, expectedDepositAmount);
//     }
// }
