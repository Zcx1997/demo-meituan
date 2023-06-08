<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <meta name="viewport" content="width=device-width,initial-scale=1.0, maximum-scale=1.0,user-scalable=no">
    <meta charset="UTF-8">
    <link rel="stylesheet" href="/demo_meituan/resources/bootstrap/bootstrap.css">
    <link rel="stylesheet" href="/demo_meituan/resources/raty/lib/jquery.raty.css">
    <script src="/demo_meituan/resources/jquery.3.3.1.min.js"></script>
    <script src="/demo_meituan/resources/bootstrap/bootstrap.min.js"></script>
    <script src="/demo_meituan/resources/raty/lib/jquery.raty.js"></script>
    <style>
        *{
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .highlight{
            background-color: lightskyblue !important;

        }
        .container {
            padding: 0px;
            margin: 0px;
        }
        .row {
            padding: 0px;
            margin: 0px;
        }
       /* .alert {
            padding-left: 0.5rem;
            padding-right: 0.5rem;
        }*/

        .description p {
            text-indent: 2em;

        }


    </style>
    <script>
        $.fn.raty.defaults.path = '/demo_meituan/resources/raty/lib/images';
        $(function () {
            $(".stars").raty({readOnly: true});
        })


        $(function () {
            $('#num').text(${food.num})
            $('#kefu').click(function (){
                $('#weixin').modal('show')
            })
            $('#shouye').click(function (){

                window.location="/demo_meituan?ts="+new Date().getTime();
            })
            //手动打开动态模态框
            /*$('#exampleModalCenter').modal('show')*/
            /*$('#dlgEvaluation').modal('show')*/
            /*$('#btc').click(function () {
                //手动打开动态模态框
                $('#exampleModalCenter').modal('hide')
            });*/
            <#if memberReadState??>
            $('[data-read-state="${memberReadState.readState}"]').addClass("highlight")
            </#if>


            <#if !loginMember??>
            $('[data-read-state],#btnEvaluation,[data-evaluation-id],#buy').click(function () {
                //alert("请登录后才能操作！")
                $('#exampleModalCenter').modal('show')
            })


            </#if>

            <#if loginMember??>
            var piao = ${loginMember.piao}
            var foodnum = ${food.num}
            $('#fanpiao').html(piao)
            $.post("/demo_meituan/ifenjoy",{
                memberId:"${loginMember.memberId}",
            },function (data){
                if (data.code=='0'){
                    for (var i = 0; i < data.list.length; i++) {

                        if (data.list[i].state=='1'){
                            $('[data-evaluation-id="'+data.list[i].evaluationId+'"]').css("background-color","red");
                        }else if (data.list[i].state=='0'){
                            $('[data-evaluation-id="'+data.list[i].evaluationId+'"]').css("background-color","#2f632f");
                        }
                    }
                }
            },"json")

            $('[data-read-state]').click(function (){
                var readState = $(this).data('read-state')
               $.post('/demo_meituan/updateReadState',{
                   "memberId":${loginMember.memberId},
                   "foodId":${food.foodId},
                   "readState":readState
               },function (date){
                    if (date.code=='0'){
                        $('[data-read-state]').removeClass("highlight")
                        $('[data-read-state="'+readState+'"]').addClass("highlight")
                    }
               },"json")
            })


            $('#btnEvaluation').click(function (){
                $('#score').raty({})//将span转换为星星组件
                $('#dlgEvaluation').modal("show")
            })

            $('#btnSubmit').click(function (){
                var score = $('#score').raty("score");
                var content = $("#content").val();
                alert(content)
                $.post("/demo_meituan/evaluate",{
                    memberId:"${loginMember.memberId}",
                    foodId: "${food.foodId}",
                    score:score,
                    content:content
                },function (data){
                    if (data.code=='0'){
                        window.location.reload()//刷新当前评论
                    }
                },"json")
            })

            $('[data-evaluation-id]').click(function (){
                var evaluationId = $(this).data("evaluation-id");
                $.post("/demo_meituan/enjoy",{evaluationId:evaluationId,memberId:"${loginMember.memberId}"},function (data){

                    if (data.code=="0"){
                        if (data.evalMem.state=="1"){
                            $('[data-evaluation-id="'+evaluationId+'"]').css("background-color","red");
                            $('[data-evaluation-id="'+evaluationId+'"] span').text(data.evaluation.enjoy)
                        }else if (data.evalMem.state=="0"){
                            $('[data-evaluation-id="'+evaluationId+'"]').css("background-color"," #2f632f");
                            $('[data-evaluation-id="'+evaluationId+'"] span').text(data.evaluation.enjoy)
                        }


                    }
                })

            })

            $('#buy').click(function (){
                $('#baoming').modal("show")
                $.post("/demo_meituan/selectpiao",{
                    memberId:"${loginMember.memberId}",
                },function (data){
                   if (data.code=='0'){
                        var piao =data.member.piao;
                        $('#fanpiao').html(piao)
                    }
                },"json")
            })

            $('#yes').click(function (){
                var nowfanpiao=$('#fanpiao').html();
                var nownum=$('#num').html();
                if (nowfanpiao<1){
                    alert("您的饭票不够")
                }else if (nownum<1){
                    alert("已经被抢完，请明天再来")
                }else {
                    $.post("/demo_meituan/baoming",{
                        memberId:"${loginMember.memberId}",
                        foodId: "${food.foodId}",
                    },function (data){
                        if (data.code==1){
                            alert("您的饭票不够")
                        }else if (data.code=='0'){
                            var piao = data.member.piao;
                            var foodnumdel = data.food.num;
                            $('#num').text(foodnumdel)
                            alert("报名成功，你现在还剩"+piao+"张票")
                            $('#fanpiao').html(piao)
                            $('#baoming').modal("hide")
                        }else if (data.code=='405'){
                            alert("已经预约过")
                            $('#baoming').modal("hide")
                        }
                    },"json")
                }

            })

            </#if>
        })
        //??表示不为空


    </script>
</head>
<body>
<div class="container">
    <!--导航部分-->
    <nav class="navbar navbar-light shadow mr-auto col-12" style="background-color:#EEB111; ">
        <!-- 导航左logo -->
        <div class="col-12 " align="center" >
            <span style="color: white;font-size: larger;" >
                店铺详情
            </span>
        </div>

    </nav>
    <!--详情部分,一行二列-->
    <div class="container mt-2 p-2 m-0" style="background-color:rgb(127, 125, 121)">
        <div class="row"><!-- 1列 -->
            <div class="mr-3" style="margin-left: 280px;position:absolute;float: right" >
                <img  class="img-fluid mt-3" src="/demo_meituan/resources/images/${food.cover}" >
            </div>
            <div class="col-8 pt-2 mb-2 pl-0">
                <h6 class="text-white">${food.foodName}</h6>
                <div class="p-1 alert alert-warning small" role="alert">${food.subTitle}</div>
               <#-- <div class="small"><span class="text-white">${food.score}</span></div>--><!--评分值-->
                <!-- 2列 -->
                <div class="small">
                    <span class="stars" data-score="${food.score}"></span><!-- 五星 -->
                </div>
                <!-- 3列 -->
                <div class=""><span class="text-white">剩余<span id="num"></span>份</span></div>

                <div class="row pl-1 pr-2">
                    <div class="col-6  p-1"><!-- 1列 -->
                        <button class="btn btn-light btn-sm w-100" data-read-state="1" >
                            <img src="/demo_meituan/resources/images/ic_mark_todo_s.png" style="width: 1rem;" class="mr-1" >取消
                        </button>
                    </div>
                    <div class="col-6 p-1"><!-- 2列 -->
                        <button class="btn btn-light btn-sm w-100" data-read-state="2">
                            <img src="/demo_meituan/resources/images/ic_mark_done_s.png" style="width: 1rem;" class="mr-1">收藏
                        </button>
                    </div>

                </div>
            </div>
        </div>
        <!--1行3列-->
        <#--<div class="row" style="background-color: rgba(0,0,0,0.1);">
            <!-- 1列 &ndash;&gt;
            <div class="col-2"><h2 class="text-white">${food.score}</h2></div><!--评分值&ndash;&gt;
            <!-- 2列 &ndash;&gt;
            <div class="col-5 pt-2">
                <span class="stars" data-score="${food.score}"></span><!-- 五星 &ndash;&gt;
            </div>
            <!-- 3列 &ndash;&gt;
            <div class="col-5 pt-2"><h5 class="text-white">${food.quantity}人已评</h5></div><!-- 评论人数量 &ndash;&gt;
        </div>-->
    </div>


    <!-- 图书描述 -->
    <div class="row p-2 description">
        下面是该餐厅的评论
    </div>
    <!--下面是短评部分, 短评的标题部分 -->
    <div class="alert alert-primary w-100 mt-2" role="alert">短评
        <button id="btnEvaluation" class="btn btn-success btn-sm text-white float-right" style="margin-top: -3px;">写短评</button>
    </div>
    <!--所有短评-->
    <div class="reply pl-2 pr-2">
        <!--这个div要进行循环，输出，这只是其中一个 #list evaluationList as evaluation-->
        <#list evaluationList as evaluation>
        <div>
            <!--短评标题-->
            <div>
                <span class="pt-1 small text-black-50 mr-2">${evaluation.createTime?string('MM-dd')}</span>
                <span class="mr-2 small pt-1">${evaluation.member.nickname}</span>
                <span class="stars mr-2" data-score="${evaluation.score}"></span>

                <button class="btn btn-success btn-sm  text-white float-right" data-evaluation-id="${evaluation.evaluationId}" style="margin-top: -3px;background-color: #2f632f">
                    <img src="/demo_meituan/resources/images/ic_like_gray.svg" class="mr-1" style="width: 24px;margin-top: -5px;">
                    <span>${evaluation.enjoy}</span><!--点赞数量-->
                </button>
            </div>
            <!--短评内容-->
            <div class="row mt-2 small mb-3">
                ${evaluation.content}
            </div>
            <hr>
        </div>
        </#list>
    </div>
    <div style="height: 40px;">

    </div>

</div>

<!--
.modal：模态框的最外层容器。
.modal-dialog：模态框的容器。
.modal-content：放置模态框的内容，设置模态框样式。
.modal-header：模态框头部。
.modal-title：模态框标题。
.modal-body：模态框主体内容。
.modal-footer：模态框页脚内容。
modal-dialog-centered 垂直居中
https://zhuanlan.zhihu.com/p/338557149
.modal('show')：手动打开动态模态框，在动态模态框实际显示之前返回给调用者（即在shown.bs.modal事件发生前)。
.modal('hide')：手动隐藏动态模态框，在动态模态框实际隐藏之前返回给调用者（即在hidden.bs.modal事件发生前)。
下面这个模态框默认隐藏，需要手动点击后显示
$('#exampleModalCenter').modal('show')
-->
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
<!--$('#dlgEvaluation').modal('show')-->
<div class="modal fade" id="dlgEvaluation" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-body">
                <h6>为 ${food.foodName} 书写短评</h6>
                <form id="frmEvaluation">
                    <div class="input-group mt-2">
                        <span id="score"></span>
                    </div>
                    <div class="input-group mt-2">
                        <input type="text" name="content" id="content" class="form-control p-4" placeholder="这里输入短评">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button id="btnSubmit" class="btn btn-primary">提交</button>
            </div>
        </div>
    </div>
</div>
<#--<div id="baoming" tabindex="-1" style="position: fixed;width: 240px;height: 300px;background-color:lightyellow;top: 100px;left: 55px;display: none">
    <span style="margin-left: 80px">报名须知</span>
    <ul style="font-size: small;margin-left: 20px;margin-right: 20px;margin-top: 20px">
        <li><svg style="margin-right: 20px" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-1-circle" viewBox="0 0 16 16">
                <path d="M1 8a7 7 0 1 0 14 0A7 7 0 0 0 1 8Zm15 0A8 8 0 1 1 0 8a8 8 0 0 1 16 0ZM9.283 4.002V12H7.971V5.338h-.065L6.072 6.656V5.385l1.899-1.383h1.312Z"/>
            </svg>每次最多可完成四次订单，超过四次订单的不在参与平台内任何外卖活动</li>
        <li style="margin-top: 10px"><svg style="margin-right: 20px" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-2-circle" viewBox="0 0 16 16">
                <path d="M1 8a7 7 0 1 0 14 0A7 7 0 0 0 1 8Zm15 0A8 8 0 1 1 0 8a8 8 0 0 1 16 0ZM6.646 6.24v.07H5.375v-.064c0-1.213.879-2.402 2.637-2.402 1.582 0 2.613.949 2.613 2.215 0 1.002-.6 1.667-1.287 2.43l-.096.107-1.974 2.22v.077h3.498V12H5.422v-.832l2.97-3.293c.434-.475.903-1.008.903-1.705 0-.744-.557-1.236-1.313-1.236-.843 0-1.336.615-1.336 1.306Z"/>
            </svg>3小时内需上传测评截图，超市未上传则是为订单取消</li>
        <li style="width: 200px;height: 50px;border: 2px solid #eeb111;font-size: larger;line-height: 50px;margin-top: 10px;text-align: center;border-radius: 10px">饭票剩余<span id="fanpiao"></span>张</li>
        <li style="font-size: smaller;color: lightgray;margin-left: 30px">本次活动需要消耗一张饭票</li>
        <li style="text-align: center"><button type="button" class="btn btn-warning" id="yes">确认使用并报名</button></li>
        <li style="text-align: center"><?xml version="1.0" encoding="UTF-8"?><svg id="guanbi" width="29" height="29" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M24 44C35.0457 44 44 35.0457 44 24C44 12.9543 35.0457 4 24 4C12.9543 4 4 12.9543 4 24C4 35.0457 12.9543 44 24 44Z" fill="none" stroke="#333" stroke-width="4" stroke-linejoin="round"/><path d="M29.6567 18.3432L18.343 29.6569" stroke="#333" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/><path d="M18.3433 18.3432L29.657 29.6569" stroke="#333" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/></svg></li>
    </ul>
</div>-->
<div class="modal fade" id="baoming" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered  ">
        <div class="modal-content ml-2 mr-2" style="background-color: lightyellow">
            <div class="modal-body">
                <h6 style="text-align: center">报名须知</h6>
                    <div class="input-group mt-2">
                        <ul class="ml-2" style="font-size: small;">
                            <li><svg  xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-1-circle mr-2" viewBox="0 0 16 16">
                                    <path d="M1 8a7 7 0 1 0 14 0A7 7 0 0 0 1 8Zm15 0A8 8 0 1 1 0 8a8 8 0 0 1 16 0ZM9.283 4.002V12H7.971V5.338h-.065L6.072 6.656V5.385l1.899-1.383h1.312Z"/>
                                </svg>每次最多可完成四次订单，超过四次订单的不在参与平台内任何外卖活动</li>
                            <li class="mt-1"><svg  xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-2-circle mr-2" viewBox="0 0 16 16">
                                    <path d="M1 8a7 7 0 1 0 14 0A7 7 0 0 0 1 8Zm15 0A8 8 0 1 1 0 8a8 8 0 0 1 16 0ZM6.646 6.24v.07H5.375v-.064c0-1.213.879-2.402 2.637-2.402 1.582 0 2.613.949 2.613 2.215 0 1.002-.6 1.667-1.287 2.43l-.096.107-1.974 2.22v.077h3.498V12H5.422v-.832l2.97-3.293c.434-.475.903-1.008.903-1.705 0-.744-.557-1.236-1.313-1.236-.843 0-1.336.615-1.336 1.306Z"/>
                                </svg>3小时内需上传测评截图，超市未上传则是为订单取消</li>
                            <li class="col-12 pt-2 pb-2 mt-2" style="border: 2px solid #eeb111;text-align: center;border-radius: 5px">饭票剩余<span id="fanpiao"> </span>张</li>
                            <li class="" style="font-size: smaller;color: lightgray;text-align: center">本次活动需要消耗一张饭票</li>
                            <li class="mt-2" style="text-align: center"><button type="button" class="btn btn-warning" id="yes">确认使用并报名</button></li>
                        </ul>
                    </div>

            </div>
        </div>
    </div>
</div>
<div id="weibu" style="width:100%; height:50px;background-color: white; position:fixed; bottom:0;" class="col-12" >
    <ul class="float-left">
        <li class="ml-3"><svg id="shouye" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-clipboard" viewBox="0 0 16 16">
                <path d="M4 1.5H3a2 2 0 0 0-2 2V14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V3.5a2 2 0 0 0-2-2h-1v1h1a1 1 0 0 1 1 1V14a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V3.5a1 1 0 0 1 1-1h1v-1z"/>
                <path d="M9.5 1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-3a.5.5 0 0 1-.5-.5v-1a.5.5 0 0 1 .5-.5h3zm-3-1A1.5 1.5 0 0 0 5 1.5v1A1.5 1.5 0 0 0 6.5 4h3A1.5 1.5 0 0 0 11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3z"/>
            </svg></li>
        <li class="ml-2">首页</li>
    </ul>
    <ul class="float-left">
        <li class="ml-4"><svg id="kefu" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-chat-left-dots" viewBox="0 0 16 16">
                <path d="M14 1a1 1 0 0 1 1 1v8a1 1 0 0 1-1 1H4.414A2 2 0 0 0 3 11.586l-2 2V2a1 1 0 0 1 1-1h12zM2 0a2 2 0 0 0-2 2v12.793a.5.5 0 0 0 .854.353l2.853-2.853A1 1 0 0 1 4.414 12H14a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2z"/>
                <path d="M5 6a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm4 0a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm4 0a1 1 0 1 1-2 0 1 1 0 0 1 2 0z"/>
            </svg></li>
        <li class="ml-3">客服</li>
    </ul>
    <ul class="float-right  mt-1">
        <button id="buy" class="btn btn-light btn-sm w-100 " style="background-color: #eeb111;border-radius: 10px;height: 40px" >
            立即抢购
        </button>
    </ul>

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
</body>
</html>
<script>

</script>
<!--
1rem等于html根元素设定的font-size的px值
如果css里面没有设定html的font-size，则默认浏览器以1rem=16px来换算。

假如我们在css里面设定下面的css
html{font-size:14px}
那么后面的CSS里面的rem值则是以这个14来换算。

例如设定一个div宽度为3rem,高度为2.5rem.
则它换算成px为width:42px.height:35px

tabindex='-1'
当使用键盘时，tabindex是个关键因素，它用来定位html元素。

tabindex有三个值：0 ，-1， 以及X（X里32767是界点，稍后说明）

原本在Html中，只有链接a和表单元素可以被键盘访问（即使是a也必须加上href属性才可以)，但是aria允许tabindex指定给任何html元素。
当tabindex=0时，该元素可以用tab键获取焦点，且访问的顺序是按照元素在文档中的顺序来focus，即使采用了浮动改变了页面中显示的顺序，
依然是按照html文档中的顺序来定位。
当tabindex=-1时，该元素用tab键获取不到焦点，但是可以通过js获取，这样就便于我们通过js设置上下左右键的响应事件来focus，
在widget内部可以用到。
当tabindex>=1时，该元素可以用tab键获取焦点，而且优先级大于tabindex=0；不过在tabindex>=1时，数字越小，越先定位到。
在IE中，tabindex范围在1到32767之间（包括32767），在FF， Chrome无限制，不过一旦超出32768，顺序跟tabindex=0时一样。
这个估计跟各个浏览器对int型的解析有关。

-->
