<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <meta name="viewport" content="width=device-width,initial-scale=1.0, maximum-scale=1.0,user-scalable=no">
    <meta charset="UTF-8">
    <link rel="stylesheet" href="resources/bootstrap/bootstrap.css">
    <link rel="stylesheet" href="resources/raty/lib/jquery.raty.css">
    <script src="resources/jquery.3.3.1.min.js"></script>
    <script src="resources/bootstrap/bootstrap.min.js"></script>
    <script src="resources/raty/lib/jquery.raty.js"></script>
    <script>
        $(function () {
            //测试弹出框
            //$('#exampleModalCenter').modal('show')
        })
    </script>
    <style>
        .container {
            padding: 0px;
            margin: 0px;
        }

    </style>
    <script>
        function reloadVerifyCode(){
            $('#imgVerifyCode').attr("src","verify_code?tp=" +new Date().getTime())
        }
        $(function (){

            $('#imgVerifyCode').click(function (){
                reloadVerifyCode();
            })
          /*  $('#btnSubmit').click(function (){
                $.ajax({
                    url:"selectyzm",
                    dataType:"text",
                    type:"get",
                    async:false,
                    success:function (res){
                        var yzm=res;
                        $('#yzm').val(yzm);
                        alert($('#yzm').val())
                    }
                })
                var yzm=$('#yzm').val()
                var mywrite=$('#verifyCode').val()
                if (yzm==mywrite){
                    $.ajax({
                        url:"saveMem",
                        dataType:"json",
                        type:"get",
                        async:false,
                        data:$('#frmLogin').serialize(),
                        success:function (res){
                            /!* alert(res)*!/
                        }
                    })
                }else {
                    alert("验证码错误")
                }

            })*/
        })
    </script>
</head>
<body>
<div class="container">
    <nav class="navbar navbar-light bg-white shadow">
        <ul class="nav">
            <li class="nav-item">
                <a href="#">
                    <img src="resources/images/logo2.jpg" class="mt-1" style="width: 100px;">
                </a>
            </li>
        </ul>
    </nav>
    <div class="container mt-2 p-2 m-0">
        <form id="frmLogin">
            <div class="passport bg-white">
                <h4 class="float-left">会员注册</h4>
                <h6 class="float-right pt-2"><a href="login">会员登录</a></h6>
                <div class="clearfix"></div>
                <div class="alert d-none mt-2" id="tips" role="alert">

                </div>

                <div class="input-group  mt-2 ">
                    <input type="text" id="username" name="username" class="form-control p-4" placeholder="请输入用户名">
                </div>

                <div class="input-group  mt-4 ">
                    <input id="password" name="password" class="form-control p-4" placeholder="请输入密码" type="password">
                </div>

                <div class="input-group  mt-4 ">
                    <input type="text" id="nickname" name="nickname" class="form-control p-4" placeholder="请输入昵称"
                    >
                </div>

                <div class="input-group mt-4 ">
                    <div class="col-5 p-0">
                        <input type="text" id="verifyCode" name="vc" class="form-control p-4" placeholder="验证码">
                    </div>
                    <div class="col-4 p-0 pl-2 pt-0">
                        <!-- 验证码图片 -->
                        <img id="imgVerifyCode" src="verify_code" style="width: 120px;height:50px;cursor: pointer">
                    </div>
                    <input type="hidden" id="yzm">
                </div>

                <a id="btnSubmit" class="btn  btn-primary  btn-block mt-4 text-white pt-3 pb-3">注 册</a>
            </div>
        </form>

    </div>
</div>
<div class="modal fade" id="exampleModalCenter" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-body">
                您已注册成功
            </div>
            <div class="modal-footer">
                <a href="login" type="button" class="btn btn-primary">去登录</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
<script>
    $('#btnSubmit').click(function () {
        var username = $.trim($('#username').val());
        var reg=/^.{1,10}$/
        if(!reg.test(username)){
            $('#tips').removeClass("d-none")
            $('#tips').hide();
            $('#tips').addClass("alert-danger");
            $('#tips').text("用户名格式应为(1-10位)");
            $('#tips').fadeIn(300);
            return;
        }else{
            $('#tips').text("");
            $('#tips').fadeOut(300);
            $('#tips').removeClass();
            $('#tips').addClass('alert');
        }
        var password = $.trim($('#password').val());
        //pwd正则处理同上，可以优化。。

        $.ajax({
            url:'regist',
            type:'post',
            dataType:'json',
            data: $('#frmLogin').serialize(),
            success:function (data){
                console.log(data);
                if (data.code==0){
                    //显示注册成功对话框
                    $('.exampleModalCenter').modal("show")
                }else {
                    $('#tips').removeClass("d-none")
                    $('#tips').hide();
                    $('#tips').addClass("alert-danger");
                    $('#tips').text("用户名已存在");
                    $('#tips').fadeIn(1000);
                    reloadVerifyCode();
                    setTimeout("ds()",3000);
                }
            }
        })





        //注册成功后，弹出提示和跳转链接
        $('#exampleModalCenter').modal('show')
    })

    function ds() {
        $('#tips').text("");
        $('#tips').fadeOut(1000);
        $('#tips').removeClass();
        $('#tips').addClass('alert');
    }
</script>
