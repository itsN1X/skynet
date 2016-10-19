
à†
proto/PActivity.protoSoulProtocolcsproto/P_Common.proto"µ
ActivityCommon
activity_id (
activity_type (
activity_name (	
revise (
begin (
close (
ui_close (
prize_begin (
prize_close	 (
activity_rule
 (	
ad_open (
ad_begin (
ad_close (
ad_interval (
advertisement (	"(
ActivityTime

id (
time ("<
ActivityTimeInfo(
info (2.SoulProtocol.ActivityTime"
ActivityReq

id ("/
	MarkExReq

activityId (
ruleId (")

detailRule
itemId (
num ("%

rewardItem

id (
num ("ž
rule*
realRule (2.SoulProtocol.detailRule(
reward (2.SoulProtocol.detailRule

id (

rewardType (
	countType (
count ("–
MarkRule!
rule1 (2.SoulProtocol.rule!
rule2 (2.SoulProtocol.rule!
rule3 (2.SoulProtocol.rule!
rule4 (2.SoulProtocol.rule"`
RankInfo

id (
level (
name (	
mark (
rank (
actorId ("q
shopItem

id (
coin (
sort (
itemId (
price (
num (
	lastPrice ("Þ
ActivityInfo

id ((
markRule (2.SoulProtocol.MarkRule
name (	
shopName (	
desc (	
mark (
rank (
	totalMark (
dest	 ((
rankInfo
 (2.SoulProtocol.RankInfo,

destReward (2.SoulProtocol.rewardItem$
shop (2.SoulProtocol.shopItem
markStartTime (
markEndTime (
itemStartTime (
itemEndTime (
coinId (
	startTime (
endTime (
price (
markRuleType ("™
MarkExSucMsg

id ($
markRule (2.SoulProtocol.rule
mark (
rank (
	totalMark ((
rankInfo (2.SoulProtocol.RankInfo"9
BuyReq

activityId (
itemId (
num ("K
ActivityShopMsg

activityId ($
item (2.SoulProtocol.shopItem"
ActivityDigestReq"y
ActivityDigestMsg3
items (2$.SoulProtocol.ActivityDigestMsg.Item/
Item

id (
title (	
type ("#
FirstRechargeQueryReq

id ("¨
FirstRechargeQueryMsg
title (	9
items (2*.SoulProtocol.FirstRechargeQueryMsg.Reward"
able (2.SoulProtocol.ACCEPT!
Reward

id (
num ("#
FirstRechargeClaimReq

id (";
FirstRechargeClaimMsg"
able (2.SoulProtocol.ACCEPT"#
DailyRechargeQueryReq

id ("¸
DailyRechargeQueryMsg
end_expire_time (
accm (9
citems (2).SoulProtocol.DailyRechargeQueryMsg.CItem¼
CItem
index (
title (	
target (?
ritems (2/.SoulProtocol.DailyRechargeQueryMsg.CItem.RItem"
able (2.SoulProtocol.ACCEPT 
RItem

id (
num ("2
DailyRechargeClaimReq

id (
index (";
DailyRechargeClaimMsg"
able (2.SoulProtocol.ACCEPT"#
AccumRechargeQueryReq

id ("Ó
AccumRechargeQueryMsg
end_expire_time (
accm (9
citems (2).SoulProtocol.AccumRechargeQueryMsg.CItem
claim_expire_time (¼
CItem
index (
title (	
target (?
ritems (2/.SoulProtocol.AccumRechargeQueryMsg.CItem.RItem"
able (2.SoulProtocol.ACCEPT 
RItem

id (
num ("ì
AccumRechargeTipMsg
end_expire_time (
accm (7
citems (2'.SoulProtocol.AccumRechargeTipMsg.CItem
claim_expire_time (
aid (
tip_type (º
CItem
index (
title (	
target (=
ritems (2-.SoulProtocol.AccumRechargeTipMsg.CItem.RItem"
able (2.SoulProtocol.ACCEPT 
RItem

id (
num ("2
AccumRechargeClaimReq

id (
index (";
AccumRechargeClaimMsg"
able (2.SoulProtocol.ACCEPT"#
ConsumeRebateQueryReq

id ("Ó
ConsumeRebateQueryMsg
end_expire_time (
accm (9
citems (2).SoulProtocol.ConsumeRebateQueryMsg.CItem
claim_expire_time (¼
CItem
index (
title (	
target (?
ritems (2/.SoulProtocol.ConsumeRebateQueryMsg.CItem.RItem"
able (2.SoulProtocol.ACCEPT 
RItem

id (
num ("2
ConsumeRebateClaimReq

id (
index (";
ConsumeRebateClaimMsg"
able (2.SoulProtocol.ACCEPT"
WheelQueryReq

id ("ä
WheelQueryMsg
end_expire_time (
title (	/
items (2 .SoulProtocol.WheelQueryMsg.Item4
refresh (2#.SoulProtocol.WheelQueryMsg.Refresh0
limit (2!.SoulProtocol.WheelQueryMsg.Limit-
use (2 .SoulProtocol.WheelQueryMsg.Item
actorId (
totalCnt (
useCnt	 (
Item

id (
num (J
Refresh
is_open (.
item (2 .SoulProtocol.WheelQueryMsg.ItemC
Limit
is_open (
total_times (
remain_times ("
WheelClaimReq

id ("ž
WheelClaimMsg
	got_index (0
limit (2!.SoulProtocol.WheelClaimMsg.Limit
refresh (/
items (2 .SoulProtocol.WheelClaimMsg.Item
totalCnt (
useCnt (
Item

id (
num (C
Limit
is_open (
total_times (
remain_times (""
DiamondWheelQueryReq

id ("ÿ
DiamondWheelQueryMsg
end_expire_time (6
items (2'.SoulProtocol.DiamondWheelQueryMsg.Item5
cost (2'.SoulProtocol.DiamondWheelQueryMsg.Item
total_times (
remain_times (
daily_reset (
Item

id (
num (""
DiamondWheelClaimReq

id ("ù
DiamondWheelClaimMsg
	got_index (6
items (2'.SoulProtocol.DiamondWheelClaimMsg.Item5
cost (2'.SoulProtocol.DiamondWheelClaimMsg.Item
total_times (
remain_times (
daily_reset (
Item

id (
num ("
WheelRefreshReq

id ("Þ
WheelRefreshMsg1
items (2".SoulProtocol.WheelRefreshMsg.Item2
limit (2#.SoulProtocol.WheelRefreshMsg.Limit
Item

id (
num (C
Limit
is_open (
total_times (
remain_times ("
DiscountHeroReq

id ("Û
DiscountHeroMsg
end_expire_time (
title (	
act_desc (	

award_desc (	
p_desc (	1
items (2".SoulProtocol.DiscountHeroMsg.Item
	show_item (
discount (	
Item

id (" 
DiscountFashionReq

id ("á
DiscountFashionMsg
end_expire_time (
title (	
act_desc (	

award_desc (	
p_desc (	4
items (2%.SoulProtocol.DiscountFashionMsg.Item
discount (	
	show_item (
Item

id ("
HolidayQueryReq

id ("®
HolidayQueryMsg
end_expire_time (
title (	
act_desc (	

award_desc (	
p_desc (	1
items (2".SoulProtocol.HolidayQueryMsg.Item
	show_item (
	max_times (
capacity_times	 (
remain_times
 (
	next_need (:-1
Item

id (
num ("
HolidayClaimReq

id ("'
HolidayClaimMsg
remain_times ("
RecallQueryReq

id ("Þ
RecallQueryMsg
end_expire_time (
act_desc (	
code (	0
items (2!.SoulProtocol.RecallQueryMsg.Itema
Item

id (
num (
called (
need (
accepted (
order_id ("
RecallClaimReq

id ("¥
RecallClaimMsg0
items (2!.SoulProtocol.RecallClaimMsg.Itema
Item

id (
num (
called (
need (
accepted (
order_id ("
FeedBackQueryReq

id ("Å
FeedBackQueryMsg
end_expire_time (
title (	
act_desc (	2
items (2#.SoulProtocol.FeedBackQueryMsg.Item"
able (2.SoulProtocol.ACCEPT
Item

id (
num (",
FeedBackClaimReq

id (
code (	"6
FeedBackClaimMsg"
able (2.SoulProtocol.ACCEPT"3
	StateInfo

id (
state (
pro ("o
UpdateStartAct%
list (2.SoulProtocol.StateInfo
dayIndex (
	typeIndex (
	starttime ("2
ReqStartAct
dayIndex (
	typeIndex ("
ReqFinishAct

id ("
UpdateActDay
day ("Y
ActSellItemInfo
item (
name (	
combat (
free (
cost ("w
ActSellItemMsg

id (+
left (2.SoulProtocol.ActSellItemInfo,
right (2.SoulProtocol.ActSellItemInfo"+
SellItemBuyReq

id (
index ("¹
ShopItem

id (
	canBuyNum (
itemId (
price (
	lastPrice (
coin (
cType (
cVal (
cTimes	 (
iconShow
 (
iconStr (	"e
ActShopInfo)
	commodity (2.SoulProtocol.ShopItem
isBuy (
begin (
close ("#
itemInfo

id (
num ("¥
Giving'
getitem (2.SoulProtocol.itemInfo(
giveitem (2.SoulProtocol.itemInfo
loginday (
getState (
	giveState (
	giveCount ("ˆ

GivingInfo"
list (2.SoulProtocol.Giving
close (
pclose (
	loginDays (
getCount (

totalCount ("
	GivingFri
dayIndex ("d

FriendInfo

id (
name (	
level (
actorId (
state (
force ("7
GivingFriList&
list (2.SoulProtocol.FriendInfo"'
ReqGive

id (
dayIndex ("L

GiveResult

id (
result ("
info (2.SoulProtocol.Giving"2
Giver

id (
actorId (
name (	"—
RecodeDetail

id ("
giver (2.SoulProtocol.Giver(
giveitem (2.SoulProtocol.itemInfo
time (
dayIndex (
state ("}
GivingRecode(
list (2.SoulProtocol.RecodeDetail
close (
pclose (
getCount (

totalCount ("
RecodeId
recodeId ("?
RecodeResult
result (
recodeId (
state ("
ExchangeInfoReq

id ("Þ
ExRule

id (
limit_level (
exchange_num (
exchange_item (
limit_amount (

limit_type (	
	canBuyNum ((
items (2.SoulProtocol.ExRule.Item
Item

id (
num ("(
ExchangeReq

id (
actId ("Œ
ExchangeInfo#
rules (2.SoulProtocol.ExRule
begin (
close (
prize_close (
prize_begin (
content (	"2
ExchangeRule"
rule (2.SoulProtocol.ExRule"*

GrowingReq

id (
infoType ("
GrowingDetail
target (
state (/
items (2 .SoulProtocol.GrowingDetail.Item
index (
Item

id (
num ("g
GrowingInfo
price (
notice (	*
lists (2.SoulProtocol.GrowingDetail
isBuy ("9

GrowingGet
infoType (
index (

id ("š
LoginDetail
notice (	
value (
state (
index (-
items (2.SoulProtocol.LoginDetail.item
item

id (
num ("u
	LoginInfo

id (*
rewards (2.SoulProtocol.LoginDetail
	loginDays (
close (
pclose ("
ReqLoginAct

id ("+
ReqLoginGet

id (
getIndex (":
LoginGetMsg

id (
getIndex (
state ("Ù
EscortActMsg/
list (2!.SoulProtocol.EscortActMsg.actmsg
state (ˆ
actmsg5
items (2&.SoulProtocol.EscortActMsg.actmsg.item

id (
desc (	-
item

id (
num (
rate ("J
posInfo#
xyz (2.SoulProtocol.PVector3

id (
radius ("¾
LuckDropActMsg5
list (2'.SoulProtocol.LuckDropActMsg.detailInfou

detailInfo"
pos (2.SoulProtocol.posInfo
scene (
	collectid (
name (	
collectTime ("
LuckDropReq

id ("@
LuckDropInfo
flag (
state (
collectTime ("
LuckDropGiveup

id ("*
LuckDropGeted

id (
figId ("
ComeBackReq

id ("
ComeBackMsg

id (
name (	
isAllowable (
isGet (
time (
content (	!
list (2.SoulProtocol.PItem"
ComeBackClaimReq

id ("A
ComeBackClaimMsg

id (!
list (2.SoulProtocol.PItem"Ó
RankLimitInfo5
rankTbl (2$.SoulProtocol.RankLimitInfo.rankInfo
myRank (
state (
time (^
rankInfo
rank (
name (	
actorId (%
avatar (2.SoulProtocol.PAvatar"Ñ
RankLimitReward4
info (2&.SoulProtocol.RankLimitReward.rankInfo‡
rankInfo:
items (2+.SoulProtocol.RankLimitReward.rankInfo.item
startR (
startE (
item

id (
num ("5
OlympicInfoReq
activity_id (
funcId ("7
OlympicTimesRefreshMsg
funcId (
times ("›
OlympicRankMsg
open (
limit (
country_num (3
items (2$.SoulProtocol.OlympicRankMsg.itemPay"
itemPay

id (
num ("l
OlympicReward4
item (2&.SoulProtocol.OlympicReward.rewardItem%

rewardItem

id (
num ("Ð
OlympicContinueMsg
open (6
group (2'.SoulProtocol.OlympicContinueMsg.Rewardt
Reward
days (;
items (2,.SoulProtocol.OlympicContinueMsg.Reward.Item
Item

id (
num ("³
OlympicMyGuessMsg
time (
activity_id (
	guessType (<
	medalInfo (2).SoulProtocol.OlympicMyGuessMsg.MedalInfo*
	MedalInfo
country (
gold ("å
OlympicMyGuessMsgWithResult
time (
activity_id (
	guessType (F
	medalInfo (23.SoulProtocol.OlympicMyGuessMsgWithResult.MedalInfo
right (9
	MedalInfo
country (
gold (
right ("p
OlympicMyGuessMsgMultiple
guessContinueDays (8
guess (2).SoulProtocol.OlympicMyGuessMsgWithResult"õ
OlympicActivityInfo,
common (2.SoulProtocol.ActivityCommon

guess_item (
	guess_num (*
rank (2.SoulProtocol.OlympicRankMsg+
medal (2.SoulProtocol.OlympicRankMsg0
serial (2 .SoulProtocol.OlympicContinueMsg"™
OlympicResultPerDay
date (	
rank (:
medal (2+.SoulProtocol.OlympicResultPerDay.MedalInfo*
	MedalInfo
country (
gold ("=
OlympicContinueGetReward
activity_id (
days ("P
OlympicMyGuessGetReward
activity_id (
time (

rewardType ("8
OlympicRewarded
activity_id (
rewarded ("
ContinusRechargeReq"ž
ContinusRechargeMsg:
dayInfo (2).SoulProtocol.ContinusRechargeMsg.DayInfoD
continusInfo (2..SoulProtocol.ContinusRechargeMsg.ContinusInfo
leftTime (#
ItemInfo

id (
num (f
DayInfo
target (<
itemInfo (2*.SoulProtocol.ContinusRechargeMsg.ItemInfo
state (m
ContinusLevelInfo
day (<
itemInfo (2*.SoulProtocol.ContinusRechargeMsg.ItemInfo
state (w
ContinusInfo
target (F
	levelInfo (23.SoulProtocol.ContinusRechargeMsg.ContinusLevelInfo
doneDay ("#
ContinusReward0Req
index ("#
ContinusReward0Msg
index ("4
ContinusReward1Req
index0 (
index1 ("4
ContinusReward1Msg
index0 (
index1 ("
RechargeRankReq

id ("¯
RechargeRankMsg

id (:
	localRank (2'.SoulProtocol.RechargeRankMsg.LocalRank<

serverRank (2(.SoulProtocol.RechargeRankMsg.ServerRank9
localReward (2$.SoulProtocol.RechargeRankMsg.Reward:
serverReward (2$.SoulProtocol.RechargeRankMsg.Reward
cnt (
leftTime (
overTime (
actType	 (
rewardState
 (•
	LocalRank

id (
cnt (
rank (%
avatar (2.SoulProtocol.PAvatar
career (
name (	
level (
force (3

ServerRank

id (
cnt (
rank (
Item

id (
num (Z
Reward
rankl (
rankr (2
reward (2".SoulProtocol.RechargeRankMsg.Item"$
RewardRankRewardReq
actId ("{
RewardRankRewardMsg
actId (4
list (2&.SoulProtocol.RewardRankRewardMsg.Item
Item

id (
num ("0
RechargeTreeReq
actId (
treeLv ("€
RechargeTreeActivityMsg
activity_id (
activity_name (	
close (
prize_close (
activity_rule (	"ù
RechargeTreeInfoMsg
actId (
dailyRecharge (
WateDiamNum (
freeWateNum (
diamWateNum (
waterLv (

waterCount (
nextLvWater (
treeLv	 (
	treeMaxLv
 (
treeGift (:

dailyItems (2&.SoulProtocol.RechargeTreeInfoMsg.Item9
	treeItems (2&.SoulProtocol.RechargeTreeInfoMsg.Item:

waterItems (2&.SoulProtocol.RechargeTreeInfoMsg.Item:

rewardItem (2&.SoulProtocol.RechargeTreeInfoMsg.Item
Item

id (
num ("ˆ
LoginActInfo

id (*
rewards (2.SoulProtocol.LoginDetail
	loginDays (
close (
pclose (
isOpen ("Q
PointShopActivityItem
nowprice (

id (
num (
times ("L
PointShopItemExchangeRecord
buyTimes (

id (
itemKey (	"j
PointShopActivityInfo,
common (2.SoulProtocol.ActivityCommon
	scoretype (
exchange ("_
PointShopActivityShop
activity_id (1
shop (2#.SoulProtocol.PointShopActivityItem"¥
PointShopActvityLimitShop
activity_id (
	shopIndex (
valid (
begin (
close (3
awards (2#.SoulProtocol.PointShopActivityItem"’
PointShopActivityRecord
activity_id (
myPoint (
limitShopCount (9
record (2).SoulProtocol.PointShopItemExchangeRecord"Y
PointShopActivityBuy
activity_id (

id (
	shopIndex (
index ("…
PointShopActivityUpdateBuyTimes
activity_id (
itemKey (	
buyTimes (

id (
myPoint (
times (*6
ACCEPT
accepted

acceptable

unaccepted