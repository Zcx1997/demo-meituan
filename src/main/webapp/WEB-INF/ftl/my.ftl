<!DOCTYPE html>
<html lang="en">
<head>
    <title>Title</title>
    <!--
    viewport 视口（可视区窗口），通过meta标签设置。
    viewport 决定了我们的页面能不能在移动端正常显示。
    viewport 默认值980，区间（768 ~ 1024）。

    width: 视口的宽度,width的值为一个正整数，或字符串device-width（设备的实际宽度 = 设备的css像素）。
    不建议设置数字（安卓设备有些不支持）
    height: 视口的高度,一般不需要设置

    user-scalable: 是否允许用户进行页面缩放（包括浏览器）值为no或yes，代表不允许与允许。
    如果不设置user-scalable=no; 移动设备的浏览器为了给用户显示更全面的信息，所以会缩放比例（缩放的不是单个元素，而是整个页面）

    initial-scale: 页面初始缩放值, 值为一个数字（可以带小数）。
    设置initial-scale=1.0；时，其实跟设置width=device-width；是一样的效果。
    设置initial-scale=1.0；时，表示不给移动设备的浏览器进行缩放，还原原始的值。
    如果同时设置width=device-width， initial-scale=1.0；时，因为两个的值都是一样的，所以无法比较。

    如果设置width=400， initial-scale=1.0；时，值不一样时，浏览器会取一个最大的值。

    initial-scale有值的情况下，计算的页面公式：
    缩放比 = css像素 / viewport宽度
    viewport宽度 = css像素 / 缩放比
    minimum-scale: 页面最小能够缩放的比例
    值为一个数字（可以带小数）。

    maximum-scale: 页面最大能够缩放的比例
    值为一个数字（可以带小数）。

    未设置viewport的时候：
    1. 屏幕的宽度默认为980，但不同的型号也会不同。
    2. 用window.innerWidth方法获取。


    注意：
    1、有的时候大家会见到同时写了不允许缩放，又写了最小与最大能够缩放的比例，那这样不是冲突了，为什么都已经写了不允许缩放了，还要写那些？

    原因：
    a.会有一些第三方工具能够破坏user-scalable，比方说一些给父母的手机把文字放大的工具，就会有可能。不过一般是没有问题的。
    b.像iphone5下还会有黑边。
    c.所以写全了，可以避免一些bug。

    2、ios10不支持user-scalable=no，后面事件能解决（阻止dosument的touchstart的默认行为）。
    -->
    <meta name="viewport" content="width=device-width,initial-scale=1.0, maximum-scale=1.0,user-scalable=no">
    <meta charset="UTF-8">
    <link rel="stylesheet" href="/demo_meituan/resources/bootstrap/bootstrap.css">
    <script src="/demo_meituan/resources/jquery.3.3.1.min.js"></script>
    <script src="/demo_meituan/resources/bootstrap/bootstrap.min.js"></script>
    <script src="/demo_meituan/resources/art-template.js"></script>
    <link rel="stylesheet" href="/demo_meituan/resources/raty/lib/jquery.raty.css">
    <script src="/demo_meituan/resources/raty/lib/jquery.raty.js"></script>
    <script>
    </script>
    <style>
        *{
            list-style: none;
        }
        .highlight{
            color: red !important;
        }

        a:active{
            text-decoration:none !important;
        }
        .container {
            padding: 0px;
            margin: 0px;
        }
        .row {
            padding: 0px;
            margin: 0px;
        }
        /* .col- * {
             padding: 0px;
         }*/
    </style>
    <script>
        //初始化星星图片目录

        $(function (){
        <#if loginMember??>
        $('#managerUser').click(function (){
            $('#user').modal('show')
            $('#memberId').val("${loginMember.memberId}")
            $('#username').val("${loginMember.username}");
            $('#password').val("");
            $('#nickname').val("${loginMember.nickname}");
        });

        $('#soucang').click(function (){
            $('#manageShoucang').modal('show')
            $.post("/demo_meituan/shoucangList",{
                memberId:"${loginMember.memberId}",
            },function (data){
                $("#soucangList").children().detach();
                $('#soucangList').append("<tr><td>编号</td><td>名称</td><td>操作</td></tr>")
                for (let i = 0; i < data.length; i++) {
                    $('#soucangList').append("<tr><td>"+data[i].foodId+"</td><td>"+data[i].foodName+"</td><td><button type='button' class='btn btn-primary btn-sm xq'>详情</button></td></tr>")
                }
            },"json")
        });

        $(document).on('click','.xq',function () {
            var Id=$(this).parent().parent().children().eq(0).text()
            window.location.href="/demo_meituan/food/"+Id;

        });

            $('#yuyue').click(function (){
                $('#wodeyuyue').modal('show')
                $.post("/demo_meituan/yuyueList",{
                    memberId:"${loginMember.memberId}",
                },function (data){
                    $("#yuyueList").children().detach();
                    $('#yuyueList').append("<tr><td>编号</td><td>名称</td><td>状态</td><td>操作</td></tr>")
                    for (let i = 0; i < data.length; i++) {
                        $('#yuyueList').append("<tr><td>"+data[i].fId+"</td><td>"+data[i].fName+"</td><td>已预约</td><td><button type='button' class='btn btn-primary btn-sm xq'>详情</button></td></tr>")
                    }
                },"json")
            });




            $("#vx").click(function (){
                $('#weixin').modal('show')
            })

            $("#exit").click(function (){
                $.post("/demo_meituan/exit",{
                },function (data){
                    if (data=='200'){
                        alert("退出成功")
                        window.location="/demo_meituan/?ts="+new Date().getTime();
                    }

                },"text")
            })





        </#if>
        })
        $(function (){
            $('#back').click(function (){
                window.location="/demo_meituan/?ts="+new Date().getTime();
            })

            $('#updateUser').click(function (){
                var type = true;
                var memberId = $('#memberId').val();
                var username =  $('#username').val();
                var password = $('#password').val();
                var nickname = $('#nickname').val();
                if (username==""||username==null){
                    alert("用户名不能为空")
                    type = false;
                }
                if (password==""||password==null){
                    alert("密码不能为空")
                    type = false;
                }
                if (nickname==""||nickname==null){
                    alert("昵称不能为空")
                    type = false;
                }

                if (type){
                    $.post("/demo_meituan/updateUser",{
                        memberId:memberId,username:username,password:password,nickname:nickname
                    },function (data){
                        alert(data);
                        $('#user').modal('hide')
                    },"text")
                }
            })

        })


    </script>

</head>
<body>
<div class="container">
    <!-- 导航部分-->
    <nav class="navbar navbar-light shadow mr-auto" style="background-color:#2283ef;text-align: center ">
        <!-- 导航左logo -->
        <div class="rol-12" align="center">
            <ul class="nav">
                <li class="nav-item" style="color: white;font-size: larger" >
                    个人首页
                </li>

            </ul>
        </div>

        <!-- 导航右登录图标 -->

            <h6 class="mt-2">
                <button id="back" type="button" class="btn btn-secondary btn-sm">返回</button>
            </h6>

    </nav>
    <!-- 第一行 -->

    <div class="col-12 mt-3">
        <ul class="list-group">
            <button type="button" class="list-group-item list-group-item-action" id="managerUser">管理我的信息</button>
            <button type="button" class="list-group-item list-group-item-action" id="soucang">管理我的收藏</button>
            <button type="button" class="list-group-item list-group-item-action" id="yuyue">查看我的购买</button>
            <button type="button" class="list-group-item list-group-item-action" id="vx">联系客服</button>
            <button type="button" class="list-group-item list-group-item-action" id="exit">退出登录</button>
        </ul>
    </div>

</div>

<div class="modal" tabindex="-1" id="user">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">修改密码</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <ul>
                    <li><input type="hidden" id="memberId"></li>
                    <li>姓名：<input type="text" id="username" readonly></li>
                    <li>密码：<input type="password" id="password"></li>
                    <li>昵称：<input type="text" id="nickname"></li>
                </ul>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="updateUser">确定修改</button>
            </div>
        </div>
    </div>
</div>

<div class="modal" tabindex="-1" id="manageShoucang">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">我的收藏</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body" >
                <table id="soucangList" class="table">

                </table>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

<div class="modal" tabindex="-1" id="wodeyuyue">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">我的购买</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body" >
                <table id="yuyueList" class="table">

                </table>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>


<div class="modal" tabindex="-1" id="fasongfankui">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">发送反馈</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body" >
                <div class="input-group">
                    <div class="input-group-prepend">
                        <span class="input-group-text">您的反馈</span>
                    </div>
                    <textarea class="form-control" aria-label="With textarea" id="fankuimsg"></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="sendFeed">确定发送</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade col-12" tabindex="-1" id="weixin">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-body" style="text-align: center">
                <img src="/demo_meituan/resources/images/weixin.jpg" width="200px"height="250px" >
            </div>
        </div>
    </div>
</div>


<#--<div id="weibu" style="width:100%; height:50px;background-color: lightgray; position:fixed; bottom:0;" class="col-12" >
    <ul class="float-left ml-5">
        <li class="ml-1"><svg id="shouye" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-clipboard" viewBox="0 0 16 16">
                <path d="M4 1.5H3a2 2 0 0 0-2 2V14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V3.5a2 2 0 0 0-2-2h-1v1h1a1 1 0 0 1 1 1V14a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V3.5a1 1 0 0 1 1-1h1v-1z"/>
                <path d="M9.5 1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-3a.5.5 0 0 1-.5-.5v-1a.5.5 0 0 1 .5-.5h3zm-3-1A1.5 1.5 0 0 0 5 1.5v1A1.5 1.5 0 0 0 6.5 4h3A1.5 1.5 0 0 0 11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3z"/>
            </svg></li>
        <li class="">精选</li>
    </ul>
    <ul class="float-right mr-5">
        <li class="ml-1"><svg id="wode" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-emoji-sunglasses" viewBox="0 0 16 16">
                <path d="M4.968 9.75a.5.5 0 1 0-.866.5A4.498 4.498 0 0 0 8 12.5a4.5 4.5 0 0 0 3.898-2.25.5.5 0 1 0-.866-.5A3.498 3.498 0 0 1 8 11.5a3.498 3.498 0 0 1-3.032-1.75zM7 5.116V5a1 1 0 0 0-1-1H3.28a1 1 0 0 0-.97 1.243l.311 1.242A2 2 0 0 0 4.561 8H5a2 2 0 0 0 1.994-1.839A2.99 2.99 0 0 1 8 6c.393 0 .74.064 1.006.161A2 2 0 0 0 11 8h.438a2 2 0 0 0 1.94-1.515l.311-1.242A1 1 0 0 0 12.72 4H10a1 1 0 0 0-1 1v.116A4.22 4.22 0 0 0 8 5c-.35 0-.69.04-1 .116z"/>
                <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-1 0A7 7 0 1 0 1 8a7 7 0 0 0 14 0z"/>
            </svg></li>
        <li class="mr-5">我的</li>
    </ul>

</div>-->
</body>
</html>
<!--
quantity 数量
.text-black-50  为黑色文本添加 50% 的不透明度
.text-white-50  为白色文本添加 50% 的不透明度
cursor:pointer  鼠标指针样式手
btn-block  显示并且宽100%
d-none 隐藏
shadow 阴影框效果
btn 变为按钮，点一下可以见框范围
 btn-light 按钮有背景色 鼠标移入按钮框，背景可变
 btn-sm    按钮框设为小屏幕，即变小
 .text-truncate {
      overflow: hidden;        溢出内容隐藏
      text-overflow: ellipsis; 单行文本不折行，显示不了就用省略号表示
      white-space: nowrap;     段落中的文本不进行换行
    }
img-fluid                   图片随父元素的宽度一起变化
img-thumbnail              图片随父元素的宽度一起变化
bg-light   背景浅灰色
w-100      width: 100%
small     字大小和粗细设置
-->
