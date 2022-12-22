const nodemailer=require("nodemailer");
const credentialManager=require("../managers/credentials-manager");
const transporter= nodemailer.createTransport({
    port:process.env.SMTP_PORT,
    host:process.env.SMTP_SERVER,
    auth:credentialManager.getSmtpCredentials(),
    secure:process.env.SMTP_SECURE==="true"
});
class SmtpSender {

    async send(mail){
       const data={
          from:mail.from.email,
          to:mail.to[0].email,
          subject:mail.subject,
          text:mail.text,
          html:mail.html
       }
       console.log("smtp email sending with the following data ",JSON.stringify(data), JSON.stringify({
        port:process.env.SMTP_PORT,
        host:process.env.SMTP_SERVER,
        auth:credentialManager.getSmtpCredentials(),
        secure:process.env.SMTP_SECURE==="true"
    }));
       const result=await transporter.sendMail(data);
       console.log("smtp email sending with the following data ",JSON.stringify(data), " mail sent");
       return result;
    }
}



const sender=new SmtpSender();
module.exports=sender;