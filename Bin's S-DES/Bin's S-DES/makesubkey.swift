////
////  File.swift
////  Bin's S-DES
////
////  Created by 조성빈 on 2022/11/16.
////
//
import Foundation
import UIKit



//S0작업_!
func S0_func(with S04bit: Array<String>) -> Array<String> {
    let S0AR = [ ["1","0","3","2"],
                 ["3","2","1","0"],
                 ["0","2","1","3"],
                 ["3","1","3","2"] ]
    var num1 : Int
    var num2 : Int
    var S0RS : [String] = []
    for i in 0..<S04bit.count {
        let s01 = S04bit[i].map{String($0)}
        let s02 = s01[0] + s01[3]
        let s03 = String(describing: s02)
        let s11 = s01[1] + s01[2]
        let s12 = String(describing: s11)
        if s03 == "00" {
            num1 = 0
        }else if s03 == "01" {
            num1 = 1
        }else if s03 == "10" {
            num1 = 2
        }else {
            num1 = 3
        }
        
        if s12 == "00" {
            num2 = 0
        }else if s12 == "01" {
            num2 = 1
        }else if s12 == "10" {
            num2 = 2
        }else {
            num2 = 3
        }
        
        let S0rs = S0AR[num1][num2]
        if S0rs == "0" {
            S0RS.append("00")
        }else if S0rs == "1" {
            S0RS.append("01")
        }else if S0rs == "2" {
            S0RS.append("10")
        }else {
            S0RS.append("11")
        }
    }
    return S0RS
}

//S1작업_!
func S1_func(with S14bit: Array<String>) -> Array<String> {
    let S0AR = [ ["0","1","2","3"],
                 ["2","0","1","3"],
                 ["3","0","1","0"],
                 ["2","1","0","3"] ]
    var num1 : Int
    var num2 : Int
    var S0RS : [String] = []
    for i in 0..<S14bit.count {
        let s01 = S14bit[i].map{String($0)}
        let s02 = s01[0] + s01[3]
        let s03 = String(describing: s02)
        let s11 = s01[1] + s01[2]
        let s12 = String(describing: s11)
        if s03 == "00" {
            num1 = 0
        }else if s03 == "01" {
            num1 = 1
        }else if s03 == "10" {
            num1 = 2
        }else {
            num1 = 3
        }
        
        if s12 == "00" {
            num2 = 0
        }else if s12 == "01" {
            num2 = 1
        }else if s12 == "10" {
            num2 = 2
        }else {
            num2 = 3
        }
        
        var S0rs = S0AR[num1][num2]
        if S0rs == "0" {
            S0RS.append("00")
        }else if S0rs == "1" {
            S0RS.append("01")
        }else if S0rs == "2" {
            S0RS.append("10")
        }else {
            S0RS.append("11")
        }
    }
    return S0RS
}

