package com.pro.controller;

import com.google.code.kaptcha.Producer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.imageio.ImageIO;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.awt.image.BufferedImage;

@Controller
public class KaptchaController {
    @Autowired
    private Producer defaultKaptcha ;//此名为<bean id="defaultKaptcha">
    @GetMapping("/verify_code")
    public void createVerifyCode(HttpServletRequest request, HttpServletResponse response) throws Exception{
        response.setDateHeader("Expires",0);    //响应立即过期
        //不缓存任何图片
        response.setHeader("Cache-Control","no-store,no-cache,must-revalidate");
        response.setHeader("Cache-Control","post-check=0,pre-check=0");
        response.setHeader("Pragma","no-cache");
        response.setContentType("image/png");
        //生成验证码文本
        String verifyCode=defaultKaptcha.createText();
        request.getSession().setAttribute("verifyCode",verifyCode);
        System.out.println(request.getSession().getAttribute("verifyCode"));
        //转图片
        BufferedImage image = defaultKaptcha.createImage(verifyCode);//创建验证码图片
        ServletOutputStream outputStream = response.getOutputStream();
        //ImageIO.setUseCache(false); 有的不加此，会报错
        ImageIO.write(image,"png",outputStream);//输出图片流
        outputStream.flush();
        outputStream.close();

    }

    @GetMapping("selectyzm")
    @ResponseBody
    public String selectyzm(HttpSession session){
        return (String)session.getAttribute("verifyCode");
    }
}
