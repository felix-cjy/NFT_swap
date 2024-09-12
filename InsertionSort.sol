// 使用 Solidity 实现一个插入排序算法
// 排序算法解决的问题是将无序的一组数字，例如[2, 5, 3, 1]，从小到大依次排列好。
// 插入排序（InsertionSort）是最简单的一种排序算法，也是很多人学习的第一个算法。
// 它的思路很简单，从前往后，依次将每一个数和排在他前面的数字比大小，如果比前面的数字小，就互换位置。

pragma solidity ^0.8.20;

contract TaskSortContract {
    function insertionSort(uint256[] memory arr) public pure returns (uint256[] memory) {
        uint256 len = arr.length;

        for (uint256 i = 1; i < len; i++) {
            uint256 key = arr[i];
            uint256 j = i - 1;
            while (j >= 0 && key < arr[j]) {
                arr[j + 1] = arr[j];
                j = j - 1;
            }
            arr[j + 1] = key;
        }
        return arr;
    }
}
