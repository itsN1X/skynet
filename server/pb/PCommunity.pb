
¶
proto/PCommunity.protoSoulProtocolcsproto/P_Common.proto"(
CommunityPlayerInfoReq
roleId ("Ñ
CommunityPlayerInfoMsg

id (
nick (	
level (
serverId (
	viewCount (
	likeCount (
picture (	
	signature (	
	bgPicture	 (	
isLiked
 (
career ("5
CommunitySettingReq
setting (	
sType ("
CommunityFriendListReq"Þ
CommunityFriendInfo
roleId (
nick (	
level (
picture (	
serverId (
career (
vip (
	signature (	
online	 (
	likeCount
 (
location (	

followTime ("+
CommunityFriendListMsg
	friendsId (" 
CommunityDelFriend

id ("H
CommunityAddFriend2
friends (2!.SoulProtocol.CommunityFriendInfo""
CommunityLikeReq
roleId (""
CommunityViewReq
roleId ("3
CommunityRecentListReq

id (
rType ("Z
CommunityLikeViewListMsg
rType (/
list (2!.SoulProtocol.CommunityFriendInfo"K
CommunityPostMessageReq
content (	
attach (	
isWorld ("+
CommunityDelMessageReq
	messageId ("<
CommunityDelMessageMsg
errorNo (
	messageId ("W
CommunityDelCommentReq
	commentId (
	messageId (
messagePlayerId ("O
CommunityDelCommentMsg
errorNo (
	commentId (
	messageId ("Z
CommunityPostMessageMsg

id (
content (	
attach (	

createTime ("Õ
PCommunityMessageInfo

id (
content (	
attach (	

createTime (
playerId (
likeNum (

forwardNum (

commentNum (

playerNick	 (	
playerPicture
 (	
playerLevel (
playerServerId (
setLiked (
playerCareer (
isWorld (
isSystem (
isDel ("S
CommunityMessageListMsg8
messageList (2#.SoulProtocol.PCommunityMessageInfo".
CommunityGetMessageListReq
playerId ("h
CommunityPostCommentReq
content (	
	messageId (
serverId (
messagePlayerId ("*
CommunityPostCommentMsg
errorNo ("Z
CommunitySetLikeMessageReq
	messageId (
serverId (
messagePlayerId ("R
CommunitySetLikeMessageMsg
errorNo (
	messageId (
serverId ("Z
CommunityGetCommentListReq
	messageId (
serverId (
messagePlayerId ("Û
PCommunityCommentInfo

id (
content (	

createTime (
playerId (
	messageId (

playerNick (	
playerPicture (	
playerLevel (
playerServerId	 (
playerCareer
 ("f
CommunityCommentListMsg
	messageId (8
commentList (2#.SoulProtocol.PCommunityCommentInfo"4
CommunityRankInfoReq
index (
rType ("Š
CommunityRankInfoMsg
index (
rType (3
infos (2$.SoulProtocol.CommunityPlayerInfoMsg
myRank (
myCount ("E
CommunityGetTimelineReq
dir (
num (
playerId ("
CommunityGetTimelineMsg
dir (
num (8
messageList (2#.SoulProtocol.PCommunityMessageInfo
playerId ("&
CommunityUploadTokenReq
num ("(
CommunityUploadTokenMsg
token (	"m
CommunityStrangerReq

id (
online (
sex (
vip (
photo (
location (	"L
CommunityStrangerMsg4
	strangers (2!.SoulProtocol.CommunityFriendInfo"{
CommunityListInfo

id (
serverId (
photo (	
career (
level (
time (
nick (	"V
CommunityRecentListMsg
rType (-
list (2.SoulProtocol.CommunityListInfo"
CommunityDailyMsgNumReq"H
CommunityDailyMsgNumMsg
dailyMsgNum (
dailyWorldMsgNum ("}
CommunityInform
iType (
	messageId (
content (	

informedId (
isWorld (

createTime (