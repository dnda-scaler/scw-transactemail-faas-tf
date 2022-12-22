class CredentialManager{

    getSmtpCredentials(){
        return {
            user:process.env.SCALEWAY_PROJECT_ID,
            pass:process.env.SCALEWAY_SECRET_KEY
        } 
    }
    getApiCredentials(){
        return {
            project_id:process.env.SCALEWAY_PROJECT_ID,
            token:process.env.SCALEWAY_SECRET_KEY
        } 
    }
}
module.exports=new CredentialManager();