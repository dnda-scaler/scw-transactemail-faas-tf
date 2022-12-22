const got=require("got");
const credentialManager=require("../managers/credentials-manager");
const SCALEWAY_REGION=process.env.SCALEWAY_REGION;
class ApiSender {

    async send(mail){
        const credentials=credentialManager.getApiCredentials();
        const parameters={...mail,...{project_id:credentials.project_id}}
        try{
            let data=await got.post(`https://api.scaleway.com/transactional-email/v1alpha1/regions/${SCALEWAY_REGION}/emails`,
            {
                body:JSON.stringify(parameters),
                headers:{
                    "X-Auth-Token": credentials.token
                }
            }).json();
        
            return data;
        }
        catch(error){
            throw new Error("Send Email fail with the following reasons " + error.response.body)
        }        
    }
}
module.exports=new ApiSender();