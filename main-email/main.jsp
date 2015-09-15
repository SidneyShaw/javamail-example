<%@page import="java.util.Properties"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page language="java" import="javax.naming.*,java.io.*,javax.mail.*,javax.mail.internet.*,com.sun.mail.smtp.*"%>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link href="assets/css/question.css" rel="stylesheet" type="text/css" media="screen" /> 
		
<body class="body">
    <div class="block_form_question">
            <form action="" name="Form" method="post" onsubmit="return validateForm()">
		
                <p><b>Ваше имя <font color="red">*</font>:</b></p>
                <p><input name="name" id="name" type="text" style="width: 40%" /></p>		
                <p><b>Ваш email <font color="red">*</font>:</b></p>
                <p><input name="email" id="email" type="text" style="width: 40%" /></p>
                <p><b>Выберите тему сообщения <font color="red">*</font>:</b></p>
                <select id="subject" name="subject" type="text" style="width: 40%">
                    <option value="ADMISSION">По поступлению</option>
                    <option value="CURRENT STUDENT">Текущий студент</option>
                    <option value="FINANCIAL">По финансам</option>
                    <option value="OTHER">Другое</option>
                </select>
                <p><b>Ваш вопрос <font color="red">*</font>:</b></p>
                <p><textarea rows="8" cols="62" name="question" id="question"></textarea></p>
				<P>
				<b>Введите код <font color="red">*</font>:</b> <span id="txtCaptchaDiv" style="background-color:#A51D22;color:#FFF;padding:5px"></span>
				<input type="hidden" id="txtCaptcha" />
				<input type="text" name="txtInput" id="txtInput" size="15" />
				</p>
                <div style="margin-top: 7px">
                    <input type="submit"  value="submit" name="submit" />
                </div>
                
            </form>
    </div>
			
	<script type="text/javascript">
			
            function validateForm()
            {
            var a=document.forms["Form"]["name"].value;
            var b=document.forms["Form"]["email"].value;
            var c=document.forms["Form"]["subject"].value;
            var d=document.forms["Form"]["question"].value;
			var e=document.forms["Form"]["txtInput"].value;
			
            if (a==null || a=="" || b==null || b=="" || c==null || c=="" || d==null || d=="" || e==null || e=="")
              {
				alert("Все поля должны быть заполнены!");
				return false;
              } else {
				if(ValidCaptcha() == false){
				alert("Введенный код не совпадает!");
				return false;
			}
			  } 

            }
			
			var a1 = Math.ceil(Math.random() * 9)+ '';
			var b1 = Math.ceil(Math.random() * 9)+ '';
			var c1 = Math.ceil(Math.random() * 9)+ '';
			var d1 = Math.ceil(Math.random() * 9)+ '';
			var e1 = Math.ceil(Math.random() * 9)+ '';
			var code = a1 + b1 + c1 + d1 + e1;
			
			document.getElementById("txtCaptcha").value = code;
			document.getElementById("txtCaptchaDiv").innerHTML = code;
			
			// Validate the Entered input aganist the generated security code function
			function ValidCaptcha(){
			var str1 = removeSpaces(document.getElementById('txtCaptcha').value);
			var str2 = removeSpaces(document.getElementById('txtInput').value);
			if (str1 == str2){
				return true;
			}else{
				return false;
			}
			}
			
			function removeSpaces(string){
				return string.split(' ').join('');
			}

			
        </script>
</body>

	<% 
            String host = "smtp.gmail.com"; 
            String SSL_FACTORY = "javax.net.ssl.SSLSocketFactory";
            String port = "465";
            String from = "******"; // gmail account email addr
            String pwd = "*******"; // gmail account pass
            String to = "*******"; // destination email
    
	if(request.getParameter("submit") != null)	{
                String name = null; 
                String email = null; 
                String question = null; 
                String subject = null; 
		boolean sessionDebug = true;
				
                if(request.getParameter("name") != null) {
                    name = request.getParameter("name");
                } 
                if(request.getParameter("email") != null) {
                    email = request.getParameter("email");
                } 
                if(request.getParameter("question") != null) {
                    question = request.getParameter("question");
                }  
                if(request.getParameter("subject") != null) {
                    subject = request.getParameter("subject");
                } 
            String text = "Name: " + name + " (" + email + ") : " + question;
            Properties props = System.getProperties();
            props.put("mail.host", host);
            props.put("mail.transport.protocol.", "smtp");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.", "true");
            props.put("mail.smtp.port", port);
            props.put("mail.smtp.socketFactory.fallback", "false");
            props.put("mail.smtp.socketFactory.class", SSL_FACTORY);
            Session mailSession = Session.getInstance(props, null); 
            mailSession.setDebug(sessionDebug);
            Message msg = new MimeMessage(mailSession);
            msg.setFrom(new InternetAddress(from));
            InternetAddress[] address = { new InternetAddress(to) };
            msg.setRecipients(Message.RecipientType.TO, address);
            msg.setSubject(subject);
            msg.setContent(text, "text/html");
            Transport transport = mailSession.getTransport("smtp");
            System.setProperty("javax.net.ssl.trustStore", "conf/jssecacerts");
            System.setProperty("javax.net.ssl.trustStorePassword", "admin");
            transport.connect(host, from, pwd);

            try {
                transport.sendMessage(msg, msg.getAllRecipients());
            } catch(Exception e) {
                out.println("Error" + e.getMessage());
            }
            transport.close();
        }
        %>
