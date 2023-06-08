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
       $.fn.raty.defaults.path='/demo_meituan/resources/raty/lib/images'
        function loadNext(isFirst){
            if (isFirst==true){
                $('#bookList').html("");
                $('#nextPage').val(1);

            }
            var nextPage=$('#nextPage').val();
            var categoryId=$('#categoryId').val();
            var order=$('#order').val();
            $.ajax({
                url:"foods",
                type:"get",
                data:{categoryId:categoryId,order:order,page:nextPage},
                dataType:'json',
                success:function (info){
                    var foodList=info.records;
                    for (var i = 0; i < foodList.length; i++) {
                        var food=foodList[i];
                        var html= template('tp1',food)
                        $('#bookList').append(html)
                    }
                   $('.stars').raty({readOnly:true})
                    //如果当前页小于总页数，则将下一页nextPage的文本框的值改为，当前页+1
                    if (info.current<info.pages){
                        $('#nextPage').val(parseInt(info.current)+1)
                        $('#btnMore').show()
                        $('#divNoMore').hide()
                    }else {
                        $('#btnMore').hide()
                        $('#divNoMore').show()
                    }
                }
            })

        }

        $(function (){

            <#if !loginMember??>
            $('#qiandao').click(function () {
                //alert("请登录后才能操作！")
                $('#exampleModalCenter').modal('show')
            })
            </#if>

            <#if loginMember??>
            $('#qiandao').click(function () {
                $.post("/demo_meituan/qiandao",{
                    memberId:"${loginMember.memberId}",
                },function (data){
                    if (data.code=='0'){
                        alert(data.msg)
                    }
                },"json")
            })
            </#if>

            loadNext(true);

            $('#btnMore').click(function (){
                loadNext();
            })

            //按类别设置高亮
            $('.category').click(function () {
                //移除当前高亮
                $('.category').removeClass("highlight")
                //设置category类的样式为灰色
                $('.category').addClass('text-black-50')
                //设置当前点击的类对应的元素，为高亮
                $(this).addClass("highlight")
                //给辅助枫叶的DIV赋值
                //首先获取到点击的类别的值
                var categoryId = $(this).data("category");
                $("#categoryId").val(categoryId)
                loadNext(true);

            })

            $('#wode').click(function (){
                window.location="/demo_meituan/wode?ts="+new Date().getTime();
            })


            $('.redu').click(function () {
                //移除当前高亮
                $('.redu').removeClass("highlight")
                //设置category类的样式为灰色
                $('.redu').addClass('text-black-50')
                //设置当前点击的类对应的元素，为高亮
                $(this).addClass("highlight")
                //给辅助枫叶的DIV赋值
                var order=$(this).data('order')
                $("#order").val(order)
                loadNext(true);

            })

        })


    </script>
    <script type="text/html" id="tp1">
        <a href="/demo_meituan/food/{{foodId}}" style="color: inherit">
            <#--   一行二列，左图，右内容 -->
            <div class="row mt-2" >
                <div class="col-4 mb-2 pr-2">
                    <img class="img-fluid" src="/demo_meituan/resources/images/{{cover}}">
                </div>
                <div class="col-4 mb-2 pl-0">
                    <h5 class="text-truncate">{{foodName}}</h5>
                    <p>
                        <#--<span data-score="{{evaluationScore}}">
                            <img src="/xzw/resources/raty/lib/images/star-on.png" alt="">
                            <img src="/xzw/resources/raty/lib/images/star-on.png" alt="">
                            <img src="/xzw/resources/raty/lib/images/star-on.png" alt="">
                            <img src="/xzw/resources/raty/lib/images/star-on.png" alt="">
                            <img src="/xzw/resources/raty/lib/images/star-on.png" alt="">
                        </span>-->
                        <span class="stars" data-score="{{score}}"></span>
                    <br>
                        <span class="mt-2 ml-2">剩余{{num}}份</span>
                        <span class="mt-2 ml-2 float-left" style="background-color: #eeb111;border-radius: 5px;padding-right:10px;padding-left: 10px;color: white">抢名额</span>
                    </p>
                </div>
            </div>
        </a>
        <hr>
    </script>

</head>
<body>
<div class="container">
    <!-- 导航部分-->
    <nav class="navbar navbar-light shadow mr-auto" style="background-color:#eeb111;text-align: center ">
        <!-- 导航左logo -->
        <div class="rol-12" align="center">
            <ul class="nav">
                <li class="nav-item" style="color: white;font-size: larger" >
                    霸王餐抢购管理系统
                </li>
                <li class="ml-5">
                    <button type="button" class="btn btn-danger" id="qiandao">签到领票</button>
                </li>
            </ul>
        </div>

        <!-- 导航右登录图标 -->
        <#if loginMember??>
            <h6 class="mt-2">
                <img  id="wode"  src="/demo_meituan/images/user.jpg" style="width:2rem;margin-top:-5px;"
                     class="mr-1">${loginMember.nickname}
            </h6>
        <#else>
            <a href="/demo_meituan/login" class="btn btn-light btn-sm">
                <img src="/demo_meituan/images/user_icon.png" style="width:2rem;margin-top:-5px;" class="mr-1">登录
            </a>
        </#if>
    </nav>
    <!-- 第一行 -->
    <div class="col-12">
        <div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
            <ol class="carousel-indicators">
                <li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
                <li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
                <li data-target="#carouselExampleIndicators" data-slide-to="2"></li>
            </ol>
            <div class="carousel-inner">
                <div class="carousel-item active">
                    <img src="/demo_meituan/resources/images/11.png" class="d-block w-100">
                </div>
                <div class="carousel-item">
                    <img src="/demo_meituan/resources/images/22.png" class="d-block w-100">
                </div>
                <div class="carousel-item">
                    <img src="/demo_meituan/resources/images/33.png" class="d-block w-100">
                </div>
            </div>
            <button class="carousel-control-prev" type="button" data-target="#carouselExampleIndicators" data-slide="prev" style="background-color: rgba(255,255,255,0);border: 0px">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="sr-only">Previous</span>
            </button>
            <button class="carousel-control-next" type="button" data-target="#carouselExampleIndicators" data-slide="next" style="background-color: rgba(255,255,255,0);border: 0px">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="sr-only">Next</span>
            </button>
        </div>
    </div>
    <div class="row mt-2">
        <div class="col-12 mt-2" style="text-align: center">
            <span data-category="-1" style="cursor:pointer;border: 1px solid lightgray;float: left" class="highlight font-weight-bold category col-3" >全部</span>
            <#list categoryList as category>
                <a style="cursor:pointer;border: 1px solid lightgray ;float: left" class="text-black-50 font-weight-bold category col-3 " data-category="${category.categoryId}">${category.categoryName}</a>
            </#list>
        </div>
        <div class="col-12 mt-2" style="text-align: center">
            <span data-order="quantity" style="cursor:pointer;border: 1px solid lightgray;float: left" class="highlight font-weight-bold text-black-50  redu col-4 ">按热度</span>
            <span data-order="score" style="cursor:pointer;border: 1px solid lightgray;float: left" class="font-weight-bold text-black-50 redu  col-4 ">按评分</span>
            <span data-order="deleteNo" style="cursor:pointer;border: 1px solid lightgray;float: left" class="font-weight-bold text-black-50 redu col-4">只看可抢</span>
        </div>
    </div>
    <!--列表，由多行组成，每行有二个div列，div1占4列，div2占8列，共12格-->
    <div id="bookList">

    </div>
    <button type="button"  id="btnMore" class="btn btn-outline-primary btn-lg btn-block">
        点击加载更多
    </button>
    <div id="divNoMore" class="text-center text-black-50 mb-5" style="display: none">没有其他数据了</div>
    <!--辅助分页-->
    <div class="d-none">
        <input type="hidden" id="nextPage" value="2">
        <input type="hidden" id="categoryId" value="-1">
        <input type="hidden" id="order" value="quantity">
    </div>
</div>

<div class="modal fade" tabindex="-1" id="exampleModalCenter">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-body">
                您要登录才可以操作！
            </div>
            <div class="modal-footer">
                <#-- <button id="btc">关闭</button>-->
                <a href="/demo_meituan/login" type="button" class="btn btn-primary">去登录</a>
            </div>
        </div>
    </div>
</div>
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
