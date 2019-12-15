---
title: lono sets status
reference: true
---

## Usage

    lono sets status STACK_SET

## Description

Show current status of stack set.

## Example

    $ lono sets status my-set
    Stack Set Operation Status: SUCCEEDED
    Stack Instance statuses... (takes a while)
    Stack Instance: account 112233445566 region ap-northeast-2 status CURRENT
    Stack Instance: account 112233445566 region ap-northeast-1 status CURRENT
    Stack Instance: account 223344556677 region us-west-1 status CURRENT
    Stack Instance: account 223344556677 region ap-northeast-1 status CURRENT
    Stack Instance: account 223344556677 region ap-northeast-2 status CURRENT
    Stack Instance: account 112233445566 region us-west-1 status CURRENT
    Stack Instance: account 112233445566 region us-west-2 status CURRENT
    Stack Instance: account 223344556677 region us-west-2 status CURRENT
    Stack Set Operation Summary:
    account 223344556677 region us-west-1 status SUCCEEDED
    account 112233445566 region us-west-2 status SUCCEEDED
    account 112233445566 region ap-northeast-1 status SUCCEEDED
    account 112233445566 region ap-northeast-2 status SUCCEEDED
    account 223344556677 region ap-northeast-2 status SUCCEEDED
    account 223344556677 region us-west-2 status SUCCEEDED
    account 112233445566 region us-west-1 status SUCCEEDED
    account 223344556677 region ap-northeast-1 status SUCCEEDED
    $



