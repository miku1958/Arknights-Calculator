//
//  BuffParser.swift
//
//
//  Created by mi on 2023/12/31.
//

import Foundation

let tag = #/[a-zA-Z1-9_]+/#
let room1 = #/人力办公室|会客室|制造站|发电站|宿舍|控制中枢|贸易站/#
let room2 = #/<@cc\.kw>(人力办公室|会客室|制造站|发电站|宿舍|控制中枢|贸易站)</>/#

let production = #/作战记录|贵金属|源石/#

let item = #/发电站|干员|无人机|联络次数|订单|仓库容量|配方|赤金生产线|人间烟火|感知信息|木天蓼|情报储备|乌萨斯特饮|巫术结晶|心情落差|思维链环|工程机器人|无声共鸣|小节|梦境|记忆碎片/#

let unit1 = #/名|个|点|架|格|层|条|次|瓶|笔|间|台/#
let unit2 = #/<@cc\.kw>(名|个|点|架|格|层|条|次|瓶|笔|间|台)</>/#

let range = #/当前|所有|每(名|个|点|架|格|层|条|次|瓶|笔|间|台)|该/#

let value1 = #/\d+%/#
let value2 = #/\d+(\.\d+)?/#
// value3 prefix + -
// value4 wrapped by cc\.v(up|down)

let `if` = #/如果|若/#
let reverse = #/反之|但/#
let make = #/则|可?使|就|对|时|后/#
let and = #/同时|且|；|;/#
let `for` = #/(可以)?为/#
