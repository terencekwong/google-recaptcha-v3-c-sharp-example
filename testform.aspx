<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">
    // create the GoogleRecaptchia object
    GoogleRecaptchia gr = new GoogleRecaptchia();


    protected void Page_Load(Object Src, EventArgs E)
    {

        if (!IsPostBack)
        {
            // insert the client side javascript into the page
            LitGoogleJS.Text = gr.GenPageCode();
        }

    }

    // process the form
    protected void Button1_Click(object sender, EventArgs e)
    {
        // create an empty string for any error messages
        string errorMessage = string.Empty;
        // validate the submission
        ReCaptchaResponse returnval = gr.ValidateReCaptcha(ref errorMessage);

        // is the ReCaptcha true or false
        bool isValidCaptcha = returnval.Success;

        // build the email body

        StringBuilder strBody = new StringBuilder();
             strBody.Append("Name: " + ContactName.Text + Environment.NewLine);
        strBody.Append("Email: " + Email.Text + Environment.NewLine);
        strBody.Append("Message: " + Comments.Text + Environment.NewLine);

     

        if (isValidCaptcha)
        {
            strBody.Append("isValidCaptcha :  true " + Environment.NewLine);
        } else
        {
            strBody.Append("isValidCaptcha : false" + Environment.NewLine);
        }
        // show the ReCaptcha score
        strBody.Append("Score : " + returnval.Score + Environment.NewLine);

        strBody.Append("Hostname : " + returnval.Hostname + Environment.NewLine);
        // show any ReCaptcha error messages
        strBody.Append("Error Message : " + errorMessage + Environment.NewLine);


        // You would now send the email but for this example we will show the response in the page.
        TxtResponse.Text = strBody.ToString();


    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Demo Form</title>
    <style>
        input, textarea { width: 99%; margin: 0 0 1em 0;}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div class="form-group">
                    <label for="<%= ContactName.ClientID %>">Your name</label>
                    <asp:TextBox ID="ContactName" runat="server" />
                </div>
                <div class="form-group">
                    <label for="<%= Email.ClientID %>">Email address</label>
                    <asp:TextBox ID="Email" runat="server" />
                </div>
              
                <div class="form-group">
                    <label for="<%= Comments.ClientID %>">Message</label>
                    <asp:TextBox ID="Comments" Rows="8" runat="server" TextMode="MultiLine" />
                </div>
                <asp:Button ID="Button1" runat="server" Text="Send Message"
                    OnClick="Button1_Click" />

            <p>Response Data</p>
            <asp:TextBox ID="TxtResponse" Rows="10" runat="server" TextMode="MultiLine" />
        </div>

        <!--  This hidden field is required to pass the Google response back to the server -->
        <input type="hidden" id="g-recaptcha-response" name="g-recaptcha-response" />
        
        <!-- Include Jquery -->
        <script
			  src="https://code.jquery.com/jquery-3.4.1.min.js"
			  integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
			  crossorigin="anonymous"></script>
			  
        <!--  asp:Literal for the client side javascript code -->
        <asp:Literal ID="LitGoogleJS" runat="server"></asp:Literal>
    </form>
</body>
</html>
