//SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract ERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals = 18;

    uint private _totalSupply;
    mapping(address => uint) private _balances;
    mapping(address => mapping(address => uint)) private _allowances;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint) {
        return _balances[account];
    }

    function transfer(address to, uint amount) public returns (bool) {
        address owner = msg.sender;
        _transfer(owner, to, amount);
        return true;
    }

    function _transfer(address from, address to, uint amount) internal {
        require(_balances[from] >= amount);
        
        _balances[from] -= amount;
        _balances[to] += amount;

        emit Transfer(from, to, amount);
    }

    function transferFrom(address from, address to, uint amount) public returns (bool) {
        address spender = msg.sender;
        _spendAllownace(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function _spendAllownace(address owner, address spender, uint amount) internal {
        uint currentAllowance = allowance(owner, spender);
        require(currentAllowance >= amount);
        _approve(owner, spender, currentAllowance - amount);
    }

    function approve(address spender, uint amount) public returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, amount);
        return true;
    }

    function _approve(address owner, address spender, uint amount) internal {
        require(owner != address(0));
        require(spender != address(0));

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function allowance(address owner, address spender) public view returns (uint) {
        return _allowances[owner][spender];
    }

    function _mint(address account, uint amount) internal {
        require(account != address(0));

        _totalSupply += amount;
        _balances[account] = amount;

        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint amount) internal {
        require(account != address(0));

        uint accountBalance = _balances[account];
        require(accountBalance >= amount);
        _balances[account] = accountBalance - amount;

        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}