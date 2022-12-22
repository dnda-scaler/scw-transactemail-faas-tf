const smtpSender=require("./sender/smtp_sender");
const apiSender=require("./sender/api_transport_sender");
const MailTransport=require("./enums/mail-transport");

async function handle (event, context, cb) {
    const {httpMethod,body}=event;
    const {mailTransport}=event.queryStringParameters;
    console.log("Event received ",JSON.stringify(event));
    if(httpMethod.toLowerCase() !="post"){
        return {
            statusCode:405,
            body:`HTTP ${httpMethod} is not supported`
        }
    }
    const mail=JSON.parse(body);
    let result={};
    console.log("Mail sending start")
    switch(mailTransport.toLowerCase()){
        case MailTransport.SMTP:
             result=await smtpSender.send(mail);
             break;
        case MailTransport.API:
            result=await apiSender.send(mail);
            break;
        default:
            return { statusCode:400, body:`Unknown ${mailTransport.toLowerCase()} Transport`}
    }
    console.log("Mail sending succeed")
    return { statusCode:200, body:JSON.stringify(result)};
}

module.exports= {handle}