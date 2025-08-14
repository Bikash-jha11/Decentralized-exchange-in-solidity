pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "contracts/LiquidityCoin.sol";

contract Poolcontract is ERC20, Liquitycoin {
    IERC20 private immutable coin0;
    IERC20 private immutable coin1;

    uint256 private res0;
    uint256 private res1;

    uint8 private fee;

    constructor(address coin_0, address coin_1) {
        coin0 = IERC20(coin_0);
        coin1 = IERC20(coin_1);
        fee = 0;
    }

    function _updatereserve(uint256 supply0, uint256 supply1) public {
        res0 = supply0;
        res1 = supply1;
    }

    //heart of dex
    function swap(address coinIn, uint256 amountIn) public {
        (
            uint256 amountOut,
            uint256 resIn,
            uint256 resOut,
            bool is_coin0
        ) = getamount(coinIn, amountIn);

        (uint256 res0, uint256 res1, IERC20 tokenIn, IERC20 tokenOut) = is_coin0
            ? (resIn + amountIn, resOut - amountOut, coin0, coin1)
            : (resIn - amountIn, resOut + amountOut, coin0, coin1);

        _updatereserve(res0, res1);

        tokenIn.transferFrom(msg.sender, address(this), amountIn);

        tokenOut.transfer(msg.sender, amountOut);
    }

    function getamount(address coinIn, uint256 amountIn)
        public
        view
        returns (
            uint256,
            uint256,
            uint256,
            bool
        )
    {
        //checking if coin is valid or not.
        require(
            address(coinIn) == address(coin0) ||
                address(coinIn) == address(coin1),
            "Invalid coin"
        );

        //checking whoch type of coin is
        bool is_coin0;
        is_coin0 = address(coinIn) == address(coin0) ? true : false;

        uint256 res0 = res0;
        uint256 res1 = res1;

        (uint256 resIn, uint256 resOut) = is_coin0
            ? (res0, res1)
            : (res1, res0);

        //lps to to paid to lp
        uint256 amountInwithfees = (amountIn * (10000 - fee)) / 10000;
        //derived formula
        uint256 amountOut = (amountInwithfees * resOut) /
            (resIn + amountInwithfees);
        return (amountOut, resIn, resOut, is_coin0);
    }

    function addLiquidity(uint256 amount0, uint256 amount1) public {
        require(amount0 > 0 && amount1 > 0, "Please add valis amount");

        require(
            res0 / res1 == amount0 / amount1,
            "Dont try to manipulate market,you fool"
        );

        uint256 liquidityTokenSupply = totalSupply();
        uint256 liquidityTokens;
        if (liquidityTokenSupply > 0) {
            liquidityTokens = (amount0 * liquidityTokenSupply) / res0;
        } else {
            //need to calculate
            liquidityTokens = _sqrt(amount0 * amount1);
        }

        _mint(msg.sender, liquidityTokens);
        _updatereserve(res0 + amount0, res1 + amount1);
    }
}

