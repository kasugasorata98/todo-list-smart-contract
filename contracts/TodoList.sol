// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract TodoList {
    struct Task {
        uint256 id;
        string description;
        bool isChecked;
        address owner;
        uint timestamp;
        bool isDeleted;
    }

    event TaskEvent (
        uint16 indexed event_id,
        uint16 id,
        string description,
        bool isChecked,
        address owner,
        uint timestamp,
        bool isDeleted
    );

    uint16 eventId = 1;

    mapping(address => uint16) public counters;
    mapping(address => mapping(uint16 => Task)) public tasks;

    constructor() {
        createTask("Create a todo-list smart contract");
    }

    function emitEvent(uint16 id) internal {
        eventId++;
        emit TaskEvent(
            eventId,
            counters[msg.sender], 
            tasks[msg.sender][id].description, 
            tasks[msg.sender][id].isChecked, 
            tasks[msg.sender][id].owner, 
            tasks[msg.sender][id].timestamp, 
            tasks[msg.sender][id].isDeleted
        );
    }

    function createTask(string memory description) public {
        counters[msg.sender]+=1;
        tasks[msg.sender][counters[msg.sender]] = Task(counters[msg.sender], description, false, msg.sender, block.timestamp, false);
        emitEvent(counters[msg.sender]);
    }

    function checkTask(uint16 id) public {
        tasks[msg.sender][id].isChecked = !tasks[msg.sender][id].isChecked;
        emitEvent(id);
    }

    function deleteTask(uint16 id) public {
        tasks[msg.sender][id].isDeleted = true;
        emitEvent(id);
    }
}