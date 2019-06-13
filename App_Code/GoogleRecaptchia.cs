using System;
using System.Text;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using System.Web;
using System.Collections.Generic;
using System.Net;

/// <summary>
/// Summary description for GoogleRecaptchia
/// </summary>
public class GoogleRecaptchia
{
    // add your google site key and secret here from the admin console
    // https://www.google.com/recaptcha/admin/
    
    public string SiteKey = "xxx";
    public string ServerKey = "xxx";
    public GoogleRecaptchia()
    {
        //
        // TODO: Add constructor logic here
        //
    }


    public string GenPageCode()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("<script src=\"https://www.google.com/recaptcha/api.js?render=" + SiteKey + "\"></script>" + Environment.NewLine);
        sb.Append("<script>" + Environment.NewLine);
        sb.Append(" $(function(){ " + Environment.NewLine);
        sb.Append("     grecaptcha.ready(function() {" + Environment.NewLine);
        sb.Append("         grecaptcha.execute('" + SiteKey + "', {action: 'homepage'}).then(function(token) {" + Environment.NewLine);
        sb.Append("          document.getElementById('g-recaptcha-response').value = token;" + Environment.NewLine);
        sb.Append("         });" + Environment.NewLine);
        sb.Append("     });" + Environment.NewLine);
        sb.Append(" });" + Environment.NewLine);
        sb.Append("</script>" + Environment.NewLine);

        return sb.ToString();;
    }

    public ReCaptchaResponse ValidateReCaptcha(ref string errorMessage)
    {
        try
        {
            var gresponse = HttpContext.Current.Request.Form["g-recaptcha-response"];
            var client = new WebClient();

            string url = string.Format("https://www.google.com/recaptcha/api/siteverify?secret={0}&response={1}&remoteip={2}", ServerKey, gresponse, GetIpAddress());

            var response = client.DownloadString(url);
            var googleresponse = JsonConvert.DeserializeObject<ReCaptchaResponse>(response);
         
                if (googleresponse.ErrorCodes != null && googleresponse.ErrorCodes.Count > 0)
                {
                    for (var i = 0; i < googleresponse.ErrorCodes.Count; i++)
                    {
                    errorMessage += googleresponse.ErrorCodes[i] + ",";
                    }

                }
       
            return googleresponse;
        }
        catch (Exception e)
        {
            errorMessage = e.ToString();
            return null;
        }
    }

    string GetIpAddress()
    {
        var ipAddress = string.Empty;

        if (HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"] != null)
        {
            ipAddress = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
        }
        else if (!string.IsNullOrEmpty(HttpContext.Current.Request.UserHostAddress))
        {
            ipAddress = HttpContext.Current.Request.UserHostAddress;
        }

        return ipAddress;
    }

    

}

public class ReCaptchaResponse
{
    [JsonProperty("success")]
    public bool Success { get; set; }

    [JsonProperty("score")]
    public float Score { get; set; }

    [JsonProperty("error-codes")]
    public List<string> ErrorCodes { get; set; }

    [JsonProperty("action")]
    public string Action { get; set; }

    [JsonProperty("hostname")]
    public string Hostname { get; set; }

}