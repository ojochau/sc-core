// Sources flattened with hardhat v2.11.1 https://hardhat.org

// File contracts/Authorization.sol

// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.13;

contract Authorization {
    address public owner;
    address public newOwner;
    mapping(address => bool) public isPermitted;
    event Authorize(address user);
    event Deauthorize(address user);
    event StartOwnershipTransfer(address user);
    event TransferOwnership(address user);
    constructor() {
        owner = msg.sender;
    }
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    modifier auth {
        require(isPermitted[msg.sender], "Action performed by unauthorized address.");
        _;
    }
    function transferOwnership(address newOwner_) external onlyOwner {
        newOwner = newOwner_;
        emit StartOwnershipTransfer(newOwner_);
    }
    function takeOwnership() external {
        require(msg.sender == newOwner, "Action performed by unauthorized address.");
        owner = newOwner;
        newOwner = address(0x0000000000000000000000000000000000000000);
        emit TransferOwnership(owner);
    }
    function permit(address user) external onlyOwner {
        isPermitted[user] = true;
        emit Authorize(user);
    }
    function deny(address user) external onlyOwner {
        isPermitted[user] = false;
        emit Deauthorize(user);
    }
}


// File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.6.0


// OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}


// File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.6.0


// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}


// File @openzeppelin/contracts/utils/Address.sol@v4.6.0


// OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)

pragma solidity ^0.8.1;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}


// File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.6.0


// OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)

pragma solidity ^0.8.0;


/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
        }
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            // Return data is optional
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}


// File contracts/AuditorInfo.sol


pragma solidity 0.8.13;
contract AuditorInfo is Authorization, ReentrancyGuard {
    using SafeERC20 for IERC20;

    enum AuditorStatus {Active, Inactive}
    struct AuditorData {
        address auditor;
        AuditorStatus status;
    }
    struct WithdrawRequest {
        uint256 amount;
        uint256 releaseTime;
    }

    IERC20 public immutable token;
    uint256 public auditorIdCount;
    uint256 public cooldownPeriod;
    uint256 public constant MAX_COOLDOWN_PERIOD = 604800; // 1 week

    mapping(uint256 => AuditorData) public auditorsData; //auditorsData[auditorId] = AuditorData
    mapping(address => uint256) public auditorIds; //auditorIds[address] = id
    mapping(uint256 => uint256) public auditorBalance; //auditorBalance[auditorId] = amount
    mapping(uint256 => WithdrawRequest) public pendingWithdrawal; //pendingWithdrawal[auditorId] = WithdrawRequest

    event AddAuditor(address indexed auditor);
    event DisableAuditor(address indexed auditor);
    event SetCooldownPeriod(uint256 cooldownPeriod);
    event StakeBond(address indexed sender, uint256 amount, uint256 newBalance);
    event UnstakeBondRequest(address indexed sender, uint256 amount, uint256 newBalance);
    event WithdrawBond(address indexed sender, uint256 amount);

    constructor(IERC20 _token, uint256 _cooldownPeriod) {
        token = _token;
        cooldownPeriod = _cooldownPeriod;
    }

    modifier onlyActiveAuditor {
        uint256 auditorId = auditorIds[msg.sender];
        require(auditorId > 0 && auditorsData[auditorId].status == AuditorStatus.Active, "not from active auditor");
        _;
    }

    function isActiveAuditor(address account) external view returns (bool) {
        uint256 auditorId = auditorIds[account];
        return auditorId > 0 && auditorsData[auditorId].status == AuditorStatus.Active;
    }

    function getAuditors(uint256 auditorIdStart, uint256 length) 
        external 
        view
        returns (
            AuditorData[] memory auditors
        ) 
    {
        if (auditorIdStart + length > auditorIdCount + 1) {
            length = auditorIdCount - auditorIdStart + 1;
        }
        auditors = new AuditorData[](length);
        for (uint256 i; i < length; i++) {
            auditors[i] = auditorsData[auditorIdStart];
            auditorIdStart++;
        }
    }

    function addAuditor(address auditor) external onlyOwner {
        uint256 auditorId = auditorIds[auditor];
        if (auditorId == 0) {
            auditorId = ++auditorIdCount;
            auditorsData[auditorId] = AuditorData({
                auditor: auditor,
                status: AuditorStatus.Active
            });
            auditorIds[auditor] = auditorId;
        }
        else {
            AuditorData storage auditorData = auditorsData[auditorId];
            require(auditorData.status == AuditorStatus.Inactive, "auditor already exists");
            auditorData.status = AuditorStatus.Active;
        }
        emit AddAuditor(auditor);
    }

    function disableAuditor(address auditor) external onlyOwner {
        uint256 auditorId = auditorIds[auditor];
        require(auditorId > 0, "auditor not exist");
        AuditorData storage auditorData = auditorsData[auditorId];
        require(auditorData.status == AuditorStatus.Active, "auditor already disabled");
        auditorData.status = AuditorStatus.Inactive;
        emit DisableAuditor(auditor);
    }

    function setCooldownPeriod(uint256 _cooldownPeriod) external onlyOwner {
        require(_cooldownPeriod <= MAX_COOLDOWN_PERIOD, "Max cooldown period > 1 week!");
        cooldownPeriod = _cooldownPeriod;
        emit SetCooldownPeriod(cooldownPeriod);
    }

    function stakeBond(uint256 amount) external onlyActiveAuditor nonReentrant {
        require(amount > 0, "amount = 0");
        amount = _transferTokenFrom(amount);
        uint256 auditorId = auditorIds[msg.sender];
        uint256 newBalance = auditorBalance[auditorId] + amount;
        auditorBalance[auditorId] = newBalance;
        emit StakeBond(msg.sender, amount, newBalance);
    }

    function unstakeBondRequest(uint256 amount) external onlyActiveAuditor nonReentrant {
        require(amount > 0, "amount = 0");
        uint256 auditorId = auditorIds[msg.sender];
        uint256 newBalance = auditorBalance[auditorId] - amount;
        auditorBalance[auditorId] = newBalance;
        if (cooldownPeriod == 0) {
            token.safeTransfer(msg.sender, amount);
            emit WithdrawBond(msg.sender, amount);
        }
        else {
            WithdrawRequest storage request = pendingWithdrawal[auditorId];
            request.amount += amount;
            request.releaseTime = block.timestamp + cooldownPeriod;
        }
        emit UnstakeBondRequest(msg.sender, amount, newBalance);
    }

    function withdrawBond() external onlyActiveAuditor nonReentrant {
        uint256 auditorId = auditorIds[msg.sender];
        WithdrawRequest storage withdrawRequest = pendingWithdrawal[auditorId];
        require(block.timestamp >= withdrawRequest.releaseTime, "please wait");
        uint256 amount = withdrawRequest.amount;
        delete pendingWithdrawal[auditorId];
        token.safeTransfer(msg.sender, amount);
        emit WithdrawBond(msg.sender, amount);
    }

    function _transferTokenFrom(uint amount) internal returns (uint256 balance) {
        balance = token.balanceOf(address(this));
        token.safeTransferFrom(msg.sender, address(this), amount);
        balance = token.balanceOf(address(this)) - balance;
    }
}


// File contracts/ProjectInfo.sol


pragma solidity 0.8.13;





contract ProjectInfo is Authorization, ReentrancyGuard {
    using SafeERC20 for IERC20;

    enum ProjectStatus {INACTIVE, ACTIVE}
    enum PackageStatus {INACTIVE, ACTIVE}
    enum PackageVersionStatus {AUDITING, AUDIT_PASSED, AUDIT_FAILED, VOIDED}

    struct ProjectVersion {
        uint256 projectId;
        uint256 version;
        string ipfsCid;
        ProjectStatus status;
        uint64 lastModifiedDate;
    }
    struct Package {
        uint256 projectId;
        uint256 currVersionIndex;
        PackageStatus status;
        string ipfsCid;
    }
    struct SemVer {
        uint256 major;
        uint256 minor;
        uint256 patch;        
    }
    struct PackageVersion {
        uint256 packageId;
        SemVer version;
        PackageVersionStatus status;
        string ipfsCid;
        string reportUri;
    }
    
    IERC20 public immutable token;
    AuditorInfo public auditorInfo;
    // active package list
    uint256 public projectCount;

    mapping(uint256 => uint256) public projectBalance; //projectBalance[projectId] = amount
    mapping(address => mapping(uint256 => uint256)) public projectBackerBalance; //projectBackerBalance[staker][projectId] = amount
    
    // project <-> owner / admin
    mapping(uint256 => address) public projectOwner; // projectOwner[projectId] = owner
    mapping(address => uint256[]) public ownersProjects; // ownersProjects[owner][ownersProjectsIdx] = projectId
    mapping(address => mapping(uint256 => uint256)) public ownersProjectsInv; // ownersProjectsInv[owner][projectId] = ownersProjectsIdx
    mapping(uint256 => address) public projectNewOwner; // projectNewOwner[projectId] = newOwner
    mapping(uint256 => address[]) public projectAdmin; // projectAdmin[projectId][idx] = admin
    mapping(uint256 => mapping(address => uint256)) public projectAdminInv; // projectAdminInv[projectId][admin] = idx

    // project meta
    ProjectVersion[] public projectVersions; // projectVersions[projectVersionIdx] = {projectId, version, ipfsCid, PackageVersionStatus}
    mapping(string => uint256) public projectVersionsInv; // projectVersionsInv[ipfsCid] = projectVersionIdx;
    mapping(uint256 => uint256) public projectCurrentVersion; // projectCurrentVersion[projectId] = projectVersionIdx;
    mapping(uint256 => uint256[]) public projectVersionList; // projectVersionList[projectId][idx] = projectVersionIdx

    // package
    Package[] public packages; // packages[packageId] = {projectId, currVersionIndex, status}
    PackageVersion[] public packageVersions; // packageVersions[packageVersionsId] = {packageId, version, status, ipfsCid}
    mapping(uint256 => uint256[]) public packageVersionsList; // packageVersionsList[packageId][idx] = packageVersionsId
    mapping(uint256 => PackageVersion) public latestAuditedPackageVersion; // latestAuditedPackageVersion[packageId] = {packageId, version, status, ipfsCid}

    // project <-> package
    mapping(uint256 => uint256[]) public projectPackages; // projectPackages[projectId][projectPackagesIdx] = packageId
    mapping(uint256 => mapping(uint256 => uint256)) public projectPackagesInv; // projectPackagesInv[projectId][packageId] = projectPackagesIdx

    event NewProject(uint256 indexed projectId, address indexed owner);
    event NewProjectVersion(uint256 indexed projectId, uint256 indexed projectVersionIdx, string ipfsCid);
    event VoidProjectVersion(uint256 indexed projectVersionIdx);
    event SetProjectCurrentVersion(uint256 indexed projectId, uint256 indexed projectVersionIdx);
    
    event TransferProjectOwnership(uint256 indexed projectId, address indexed newOwner);
    event AddAdmin(uint256 indexed projectId, address indexed admin);
    event RemoveAdmin(uint256 indexed projectId, address indexed admin);

    event NewPackage(uint256 indexed projectId, uint256 indexed packageId, string ipfsCid);
    event UpdatePackageIpfsCid(uint256 indexed packageId, string ipfsCid);
    event NewPackageVersion(uint256 indexed packageId, uint256 indexed packageVersionId, SemVer version);
    event SetPackageVersionStatus(uint256 indexed packageId, uint256 indexed packageVersionId, PackageVersionStatus status);
    // event AddProjectPackage(uint256 indexed projectId, uint256 indexed packageId);
    // event RemoveProjectPackage(uint256 indexed projectId, uint256 indexed packageId);

    event Stake(address indexed sender, uint256 indexed projectId, uint256 amount, uint256 newBalance);
    event Unstake(address indexed sender, uint256 indexed projectId, uint256 amount, uint256 newBalance);

    constructor(IERC20 _token, AuditorInfo _auditorInfo) {
        token = _token;
        auditorInfo = _auditorInfo;
    }

    modifier onlyProjectOwner(uint256 projectId) {
        require(projectOwner[projectId] == msg.sender, "not from owner");
        _;
    }

    modifier isProjectAdminOrOwner(uint256 projectId) {
        require(projectAdmin[projectId].length > 0 &&  
            projectAdmin[projectId][projectAdminInv[projectId][msg.sender]] == msg.sender 
            || projectOwner[projectId] == msg.sender
        , "not from admin");
        _;
    }

    modifier onlyActiveAuditor {
        require(auditorInfo.isActiveAuditor(msg.sender), "not from active auditor");
        _;
    }

    function ownersProjectsLength(address owner) external view returns (uint256 length) {
        length = ownersProjects[owner].length;
    }
    function projectAdminLength(uint256 projectId) external view returns (uint256 length) {
        length = projectAdmin[projectId].length;
    }
    function projectVersionsLength() external view returns (uint256 length) {
        length = projectVersions.length;
    }
    function projectVersionListLength(uint256 projectId) external view returns (uint256 length) {
        length = projectVersionList[projectId].length;
    }
    function packagesLength() external view returns (uint256 length) {
        length = packages.length;
    }
    function packageVersionsLength() external view returns (uint256 length) {
        length = packageVersions.length;
    }
    function packageVersionsListLength(uint256 packageId) external view returns (uint256 length) {
        length = packageVersionsList[packageId].length;
    }
    function projectPackagesLength(uint256 projectId) external view returns (uint256 length) {
        length = projectPackages[projectId].length;
    }

    //
    // functions called by project owners
    //
    function newProject(string calldata ipfsCid) external returns (uint256 projectId) {
        projectId = projectCount;
        projectOwner[projectId] = msg.sender;
        ownersProjectsInv[msg.sender][projectId] = ownersProjects[msg.sender].length;
        ownersProjects[msg.sender].push(projectId);
        projectCount++;
        emit NewProject(projectId, msg.sender);
        uint256 versionIdx = newProjectVersion(projectId, ipfsCid);
        projectCurrentVersion[projectId] = versionIdx;
    }
    function _removeProjectFromOwner(address owner, uint256 projectId) internal {
        // make sure the project ownership is checked !
        uint256 idx = ownersProjectsInv[owner][projectId];
        uint256 lastIdx = ownersProjects[owner].length - 1;
        if (idx < lastIdx) {
            uint256 lastProjectId = ownersProjects[owner][lastIdx];
            ownersProjectsInv[owner][lastProjectId] = idx;
            ownersProjects[owner][idx] = lastProjectId;
        }
        delete ownersProjectsInv[owner][projectId];
        ownersProjects[owner].pop();
    }
    function transferProjectOwnership(uint256 projectId, address newOwner) external onlyProjectOwner(projectId) {
        
        projectNewOwner[projectId] = newOwner;
    }
    function takeProjectOwnership(uint256 projectId) external {
        require(projectNewOwner[projectId] == msg.sender, "not from new owner");
        address prevOwner = projectOwner[projectId];
        projectOwner[projectId] = msg.sender;
        projectNewOwner[projectId] = address(0);

        _removeProjectFromOwner(prevOwner, projectId);

        emit TransferProjectOwnership(projectId, msg.sender);
    }
    function addProjectAdmin(uint256 projectId, address admin) external onlyProjectOwner(projectId) {
        require(projectAdmin[projectId].length == 0 || projectAdmin[projectId][projectAdminInv[projectId][admin]] != admin, "already a admin");
        projectAdminInv[projectId][admin] = projectAdmin[projectId].length;
        projectAdmin[projectId].push(admin);

        emit AddAdmin(projectId, admin);
    }
    function removeProjectAdmin(uint256 projectId, address admin) external onlyProjectOwner(projectId) {
        uint256 idx = projectAdminInv[projectId][admin];
        uint256 lastIdx = projectAdmin[projectId].length - 1;
        if (idx < lastIdx) {
            address lastAdmin = projectAdmin[projectId][lastIdx];
            projectAdminInv[projectId][lastAdmin] = idx;
            projectAdmin[projectId][idx] = lastAdmin;
        }
        delete projectAdminInv[projectId][admin];
        projectAdmin[projectId].pop();

        emit RemoveAdmin(projectId, admin);
    }
    function newProjectVersion(uint256 projectId, string calldata ipfsCid) public isProjectAdminOrOwner(projectId) returns (uint256 versionIdx) {
        versionIdx = projectVersions.length;
        projectVersionList[projectId].push(versionIdx); // start from 0

        projectVersionsInv[ipfsCid] = versionIdx;
        projectVersions.push(ProjectVersion({
            projectId: projectId,
            version: projectVersionList[projectId].length, // start from 1
            ipfsCid: ipfsCid,
            status: ProjectStatus.ACTIVE,
            lastModifiedDate: uint64(block.timestamp)
        }));
        emit NewProjectVersion(projectId, versionIdx, ipfsCid);
    }
    function setProjectCurrentVersion(uint256 projectId, uint256 versionIdx) external isProjectAdminOrOwner(projectId) {
        require(versionIdx < projectVersions.length, "project not exist");
        ProjectVersion storage version = projectVersions[versionIdx];
        require(version.projectId == projectId, "projectId/versionIdx not match");
        projectCurrentVersion[projectId] = versionIdx;
        emit SetProjectCurrentVersion(projectId, versionIdx);
    }
    function voidProjectVersion(uint256 projectId, uint256 versionIdx) external isProjectAdminOrOwner(projectId) {
        require(versionIdx < projectVersions.length, "project not exist");
        ProjectVersion storage version = projectVersions[versionIdx];
        require(version.projectId == projectId, "projectId/versionIdx not match");
        version.status = ProjectStatus.INACTIVE;
        version.lastModifiedDate = uint64(block.timestamp);
        emit VoidProjectVersion(versionIdx);
    }
    function newPackage(uint256 projectId, string calldata ipfsCid) external isProjectAdminOrOwner(projectId) returns (uint256 packageId) {
        packageId = packages.length;
        packages.push(Package({
            projectId: projectId,
            currVersionIndex: 0,
            status: PackageStatus.ACTIVE,
            ipfsCid: ipfsCid
        }));
        projectPackages[projectId].push(packageId);
        emit NewPackage(projectId, packageId, ipfsCid);
    }
    function updatePackageIpfsCid(uint256 projectId, uint256 packageId, string calldata ipfsCid) external isProjectAdminOrOwner(projectId) {
        require(packageId < packages.length, "invalid packageId");
        Package storage package = packages[packageId];
        require(package.projectId == projectId, "projectId/packageId not match");
        package.ipfsCid = ipfsCid;
        emit UpdatePackageIpfsCid(packageId, ipfsCid);
    }

    function newPackageVersion(uint256 projectId, uint256 packageId, SemVer memory version, string calldata ipfsCid) public isProjectAdminOrOwner(projectId) returns (uint256 packageVersionId) {
        require(packageId < packages.length, "invalid packageId");
        require(packages[packageId].projectId == projectId, "projectId/packageId not match");
        uint256 versionsLength = packageVersionsList[packageId].length;
        if (versionsLength > 0) {
            uint256 lastVersionId = packageVersionsList[packageId][versionsLength - 1];
            PackageVersion memory lastPackageVersion = packageVersions[lastVersionId];
            if (lastPackageVersion.version.major == version.major) {
                if (lastPackageVersion.version.minor == version.minor) {
                    require(version.patch > lastPackageVersion.version.patch, "patch version must be bumped");
                }
                else {
                    require(version.minor > lastPackageVersion.version.minor, "minor version must be bumped");
                }
            }
            else {
                require(version.major > lastPackageVersion.version.major, "major version must be bumped");
            }
        }        
        packageVersionId = packageVersions.length;
        packageVersionsList[packageId].push(packageVersionId);
        packageVersions.push(PackageVersion({
            packageId: packageId,
            version: version,
            status: PackageVersionStatus.AUDITING,
            ipfsCid: ipfsCid,
            reportUri: ""
        }));

        emit NewPackageVersion(packageId, packageVersionId, version);
    }

    function _setPackageVersionStatus(PackageVersion storage packageVersion, uint256 packageVersionId, PackageVersionStatus status) internal {
        packageVersion.status = status;
        emit SetPackageVersionStatus(packageVersion.packageId, packageVersionId, status);
    }

    function voidPackageVersion(uint256 packageVersionId) external {
        require(packageVersionId < packageVersions.length, "invalid packageVersionId");
        PackageVersion storage packageVersion = packageVersions[packageVersionId];
        require(packageVersion.status != PackageVersionStatus.VOIDED, "already voided");
        require(packageVersion.status != PackageVersionStatus.AUDIT_PASSED, "Audit passed version cannot be voided");
        _setPackageVersionStatus(packageVersion, packageVersionId, PackageVersionStatus.VOIDED);
    }
    function setPackageVersionToAuditPassed(uint256 packageVersionId, string calldata reportUri) external onlyActiveAuditor {
        require(packageVersionId < packageVersions.length, "invalid packageVersionId");
        PackageVersion storage packageVersion = packageVersions[packageVersionId];
        require(packageVersion.status == PackageVersionStatus.AUDITING, "not under auditing");
        latestAuditedPackageVersion[packageVersion.packageId] = packageVersion;
        packageVersion.reportUri = reportUri;
        _setPackageVersionStatus(packageVersion, packageVersionId, PackageVersionStatus.AUDIT_PASSED);
    } 
    function setPackageVersionToAuditFailed(uint256 packageVersionId, string calldata reportUri) external onlyActiveAuditor {
        require(packageVersionId < packageVersions.length, "invalid packageVersionId");
        PackageVersion storage packageVersion = packageVersions[packageVersionId];
        require(packageVersion.status == PackageVersionStatus.AUDITING, "not under auditing");
        packageVersion.reportUri = reportUri;
        _setPackageVersionStatus(packageVersion, packageVersionId, PackageVersionStatus.AUDIT_FAILED);
    }         
    // function addProjectPackage(uint256 projectId, uint256 packageId) external isProjectAdminOrOwner(projectId) {
    //     require(packageId < packages.length, "invalid packageId");
    //     projectPackagesInv[projectId][packageId] = projectPackages[projectId].length;
    //     projectPackages[projectId].push(packageId);

    //     emit AddProjectPackage(projectId, packageId);
    // }
    // function removeProjectPackage(uint256 projectId, uint256 packageId) external isProjectAdminOrOwner(projectId) {
    //     uint256 idx = projectPackagesInv[projectId][packageId];
    //     uint256 lastIdx = projectPackages[projectId].length - 1;
    //     if (idx < lastIdx) {
    //         uint256 lastPackageId = projectPackages[projectId][lastIdx];
    //         projectPackagesInv[projectId][lastPackageId] = idx;
    //         projectPackages[projectId][idx] = lastPackageId;
    //     }
    //     delete projectPackagesInv[projectId][packageId];
    //     projectPackages[projectId].pop();

    //     emit RemoveProjectPackage(projectId, packageId);        
    // }

    function stake(uint256 projectId, uint256 amount) external nonReentrant {
        require(amount > 0, "amount = 0");
        amount = _transferTokenFrom(amount);
        uint256 newBalance = projectBackerBalance[msg.sender][projectId] + amount;
        projectBackerBalance[msg.sender][projectId] = newBalance;
        projectBalance[projectId] += amount;
        emit Stake(msg.sender, projectId, amount, newBalance);
    }

    function unstake(uint256 projectId, uint256 amount) external nonReentrant {
        require(amount > 0, "amount = 0");
        uint256 newBalance = projectBackerBalance[msg.sender][projectId] - amount;
        projectBackerBalance[msg.sender][projectId] = newBalance;
        projectBalance[projectId] -= amount;
        token.safeTransfer(msg.sender, amount);
        emit Unstake(msg.sender, projectId, amount, newBalance);
    }

    function _transferTokenFrom(uint amount) internal returns (uint256 balance) {
        balance = token.balanceOf(address(this));
        token.safeTransferFrom(msg.sender, address(this), amount);
        balance = token.balanceOf(address(this)) - balance;
    }
}
