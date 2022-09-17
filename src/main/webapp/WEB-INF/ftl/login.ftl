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
        .container {
            padding: 0px;
            margin: 0px;
        }

    </style>
    <script>
        $(function () {
            //单击图片换验证码
            $('#imgVerifyCode').click(function () {
                reloadVerifyCode();
            })
        })
        function reloadVerifyCode() {
            //给时间戳防止缓存
            $('#imgVerifyCode').attr("src","verify_code?tp="+new Date().getTime())
        }
    </script>
</head>
<body>
<div class="container">
    <!--导航-->
    <nav class="navbar navbar-light bg-white shadow">
        <ul class="nav">
            <li class="nav-item">
                <a href="#">
                    <img src="/demo_meituan/resources/images/logo2.jpg" class="mt-1" style="width: 100px;">
                </a>
            </li>
        </ul>
    </nav>

    <div class="col-12" style="text-align: center">
        <img src="/demo_meituan/resources/images/1234.png" style="width: 50%;height: 50%" >
    </div>
    <!-- 表单 -->
    <div class="container mt-2 p-2 m-0">
        <form id="frmLogin">
            <div class="passport bg-white">
                <h4 class="float-left pl-2">会员登录</h4>
                <h6 class="float-right pt-2 pr-2"><a href="register">会员注册</a></h6>
                <div class="clearfix"></div>
                <div class="alert d-none mt-2" id="tips">

                </div>
                <div class="input-group mt-2">
                    <input type="text" name="username" id="username" class="form-control p-4" placeholder="请输入用户名">
                </div>
                <div class="input-group mt-4">
                    <input type="password" name="password" id="password" class="form-control p-4" placeholder="请输入密码">
                </div>
                <div class="input-group mt-4">
                    <div class="col-5 p-0">
                        <input type="text" name="vc" id="verifyCode" class="form-control p-4" placeholder="验证码">
                    </div>
                    <div class="col-4 p-0 pl-2 pt-0">
                        <img id="imgVerifyCode" src="verify_code" style="width: 120px;height: 50px;cursor: pointer">
                    </div>
                </div>
                <a href="#" id="btnSubmit" class="btn btn-success btn-block mt-4 text-white pt-3 pb-3">
                    登录
                </a>
            </div>
        </form>
    </div>
</div>
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

        $(this).text("正在处理...");
        //alert('$.ajax...'+username+","+password)
        $.ajax({
            url:'checkLogin',
            type:'post',
            dataType:'json',
            data:$('#frmLogin').serialize(),
            success:function (data) {
                console.log(data);
                if (data.code=="0"){
                    //重新发请求到index，跳转到首页
                    window.location="/demo_meituan?ts="+new Date().getTime();
                }else {
                    $('#tips').removeClass("d-none")
                    $('#tips').hide();
                    $('#tips').addClass("alert-danger");
                    $('#tips').text(data.msg);
                    $('#tips').fadeIn(300);
                    //登录失败 刷个新的验证码
                    reloadVerifyCode();

                }
            }

        })

    })
</script>
</body>
</html>