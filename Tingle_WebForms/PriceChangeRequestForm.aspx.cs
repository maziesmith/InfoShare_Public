﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Tingle_WebForms.Models;
using Tingle_WebForms.Logic;
using System.Text;

namespace Tingle_WebForms
{
    public partial class PriceChangeRequestForm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            UserLogic newLogic = new UserLogic();

            System.Security.Principal.IPrincipal user = System.Web.HttpContext.Current.User;
            SystemUsers currentUser = newLogic.GetCurrentUser(user);

            if (newLogic.HasAccess(currentUser, "Price Change Request"))
            {
                string msg = "";

                string formAction = Request.QueryString["FormAction"];
                if (!String.IsNullOrEmpty(formAction))
                {
                    if (formAction == "add")
                    {
                        msg = "Price Change Request Form successfully submitted.";
                        pnlCompleted.Visible = true;
                        pnlForm.Visible = false;
                    }
                    else
                    {
                        pnlCompleted.Visible = false;
                        pnlForm.Visible = true;
                    }
                }

                string sendEmail = Request.QueryString["sendEmail"];
                if (!String.IsNullOrEmpty(sendEmail))
                {
                    if (sendEmail.ToLower() == "false")
                    {
                        msg += " Some or all of the email notifications have failed.  Please contact support@wctingle.com for more information.";
                    }
                }

                lblMessage.Text = msg;

                ddlNotifyOther.OpenDropDownOnLoad = false;

                if (!IsPostBack)
                {
                    FillEmailAddressLabels();

                    cbNotifyStandard.Checked = false;
                    cbNotifyRequester.Checked = false;
                    cbNotifyOther.Checked = false;
                    cbNotifyAssignee.Checked = false;
                }
            }
            else
            {
                Response.Redirect("/Default");
            }
        }

        public void FillEmailAddressLabels()
        {
            lblNotifyAssigneeValue.Text = ddlAssignedTo.SelectedIndex != -1 ? ddlAssignedTo.SelectedItem.Text : "";
            lblNotifyRequesterValue.Text = ddlRequestedBy.SelectedIndex != -1 ? ddlRequestedBy.SelectedItem.Text : "";
            lblNotifyStandardValue.Text = ddlCompany.SelectedText;

            List<String> listEmails = new List<String>();

            if (cbNotifyStandard.Checked)
            {
                using (FormContext ctx = new FormContext())
                {
                    if (ctx.EmailAddresses.Any(x => x.Status == 1 && x.TForm.FormName == "Price Change Request" && x.Company == ddlCompany.SelectedText))
                    {
                        ICollection<EmailAddress> emailAddresses = ctx.EmailAddresses.Where(x => x.Status == 1 && x.TForm.FormName == "Price Change Request" && x.Company == ddlCompany.SelectedText).ToList();

                        if (emailAddresses.Count() > 0)
                        {
                            foreach (EmailAddress email in emailAddresses)
                            {
                                listEmails.Add(email.Address);
                            }
                        }
                    }
                }
            }

            if (cbNotifyAssignee.Checked)
            {
                if (lblNotifyAssigneeValue.Text != "")
                {
                    listEmails.Add(lblNotifyAssigneeValue.Text);
                }
            }

            if (cbNotifyRequester.Checked)
            {
                if (lblNotifyRequesterValue.Text != "")
                {
                    listEmails.Add(lblNotifyRequesterValue.Text);
                }
            }

            if (cbNotifyOther.Checked)
            {
                var notifyOtherList = ddlNotifyOther.CheckedItems;

                if (notifyOtherList.Any())
                {
                    foreach (var item in notifyOtherList)
                    {
                        if (item.Text != null)
                        {
                            listEmails.Add(item.Text);
                        }
                    }
                }

            }


            string emailList = "";

            foreach (string email in listEmails)
            {
                emailList += email + ", ";
            }


            if (emailList.Length >= 2)
            {
                if (emailList.Substring(emailList.Length - 2, 2) == ", ")
                {
                    emailList = emailList.Substring(0, emailList.Length - 2);
                }
            }


            lblEmailsSentTo.Text = emailList;
        }

        public IEnumerable<Status> GetStatuses()
        {
            FormContext ctx = new FormContext();
            var StatusList = ctx.Statuses.ToList();

            return StatusList;
        }

        public IEnumerable<SystemUsers> GetUsers()
        {
            using (FormContext ctx = new FormContext())
            {
                if (ctx.SystemUsers.Any(x => x.Status == 1))
                {
                    var userList = ctx.SystemUsers.Where(x => x.Status == 1).ToList();

                    return userList.OrderBy(x => x.DisplayName);
                }
                else
                {
                    return null;
                }
            }
        }

        public IEnumerable<NotifyOtherList> GetOtherEmails()
        {
            try
            {
                using (FormContext ctx = new FormContext())
                {
                    var userList = from s in ctx.SystemUsers
                                   select new NotifyOtherList { Address = s.EmailAddress, Name = s.DisplayName };

                    var otherList = from n in ctx.NotificationEmailAddresses
                                    select new NotifyOtherList { Address = n.Address, Name = n.Name };

                    return userList.Union(otherList).ToList().OrderBy(x => x.Name);

                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public IEnumerable<Priority> GetPriorities()
        {
            using (FormContext ctx = new FormContext())
            {
                var priList = ctx.Priorities.ToList();

                return priList;
            }

        }

        public IEnumerable<PriceChangeRequestProducts> GetProducts()
        {
            using (FormContext ctx = new FormContext())
            {
                var prodList = ctx.PriceChangeRequestProducts.ToList();

                return prodList;
            }

        }

        protected void lbStartOver_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/default.aspx");
            lblMessage.Visible = false;

            lbStartOver.Visible = false;
            txtCustomer.Enabled = true;
            txtLineNumber.Enabled = true;
            txtAccountNumber.Enabled = true;
            txtQuantity.Enabled = true;
            txtSalesRep.Enabled = true;
            ddlProduct.Enabled = true;
            txtOrderNumber.Enabled = true;
            txtPrice.Enabled = true;
            txtCrossRefOldOrderNumber.Enabled = true;
            ddlCompany.Enabled = true;
            ddlRequestedBy.Enabled = true;
            ddlAssignedTo.Enabled = true;
            txtDueByDate.Disabled = false;
            ddlStatus.Enabled = true;
            ddlPriority.Enabled = true;
            cbNotifyStandard.Enabled = true;
            cbNotifyRequester.Enabled = true;
            cbNotifyOther.Enabled = true;
            cbNotifyAssignee.Enabled = true;
            cbSendComments.Enabled = true;
            txtComments.Enabled = true;
            txtSKU.Enabled = true;
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            try
            {
                if (Page.IsValid)
                {
                    Int32 formId;
                    int statusId;
                    DateTime tryDueDate;
                    Nullable<DateTime> dueDate = null;
                    string emailListString = lblEmailsSentTo.Text.Replace(" ", "");
                    List<string> emailList = emailListString.Split(',').ToList<string>();

                    string accountNumber = txtAccountNumber.Text;
                    int accountNumberLength = txtAccountNumber.Text.Length;

                    while (accountNumberLength < 6)
                    {
                        accountNumber = "0" + accountNumber;
                        accountNumberLength++;
                    }

                    System.Security.Principal.IPrincipal user = System.Web.HttpContext.Current.User;
                    UserLogic uLogic = new UserLogic();
                    SystemUsers currentUser = uLogic.GetCurrentUser(user);

                    if (txtDueByDate.Value != "")
                    {
                        DateTime.TryParse(txtDueByDate.Value, out tryDueDate);

                        if (tryDueDate.Year > 0001)
                        {
                            dueDate = tryDueDate;
                        }
                    }
                    else
                    {
                        dueDate = null;
                    }

                    statusId = Convert.ToInt32(ddlStatus.SelectedValue);

                    using (FormContext ctx = new FormContext())
                    {
                        var status = ctx.Statuses.FirstOrDefault(s => s.StatusId.Equals(statusId));
                        Int32 requestedUserId = Convert.ToInt32(ddlRequestedBy.SelectedValue);
                        var requestedUser = ctx.SystemUsers.FirstOrDefault(x => x.SystemUserID == requestedUserId);
                        var modifiedUser = ctx.SystemUsers.FirstOrDefault(x => x.SystemUserID == currentUser.SystemUserID);

                        Models.PriceChangeRequestForm newPriceChangeRequestForm = new Models.PriceChangeRequestForm
                        {
                            Timestamp = DateTime.Now,
                            Company = ddlCompany.SelectedValue,
                            Customer = txtCustomer.Text,
                            LineNumber = txtLineNumber.Text,
                            AccountNumber = accountNumber,
                            Quantity = txtQuantity.Text,
                            SKU = txtSKU.Text,
                            SalesRep = txtSalesRep.Text,
                            Product = ctx.PriceChangeRequestProducts.FirstOrDefault(x => x.ProductText == ddlProduct.SelectedText),
                            OrderNumber = txtOrderNumber.Text,
                            Price = txtPrice.Text,
                            CrossReferenceOldOrderNumber = txtCrossRefOldOrderNumber.Text,
                            Status = ctx.Statuses.FirstOrDefault(s => s.StatusText == ddlStatus.SelectedItem.Text),
                            RequestedUser = requestedUser,
                            LastModifiedUser = modifiedUser,
                            SubmittedUser = ctx.SystemUsers.FirstOrDefault(x => x.SystemUserID == currentUser.SystemUserID),
                            DueDate = dueDate,
                            Priority = ctx.Priorities.FirstOrDefault(x => x.PriorityText == ddlPriority.SelectedText),
                            LastModifiedTimestamp = DateTime.Now
                        };

                        if (ddlAssignedTo.SelectedIndex != -1)
                        {
                            Int32 assignedUserId = Convert.ToInt32(ddlAssignedTo.SelectedValue);
                            newPriceChangeRequestForm.AssignedUser = ctx.SystemUsers.FirstOrDefault(x => x.SystemUserID == assignedUserId);
                        }

                        ctx.PriceChangeRequestForms.Add(newPriceChangeRequestForm);
                        ctx.SaveChanges();

                        if (newPriceChangeRequestForm.AssignedUser != null)
                        {
                            Int32 assignedUserId = Convert.ToInt32(ddlAssignedTo.SelectedValue);

                            UserAssignmentAssociation uA = new UserAssignmentAssociation
                            {
                                Form = ctx.TForms.FirstOrDefault(x => x.FormName == "Price Change Request"),
                                RelatedFormId = newPriceChangeRequestForm.RecordId,
                                User = ctx.SystemUsers.FirstOrDefault(x => x.SystemUserID == assignedUserId)
                            };

                            ctx.UserAssignments.Add(uA);
                        }

                        if (newPriceChangeRequestForm.RequestedUser != null)
                        {
                            UserRequestAssociation uR = new UserRequestAssociation
                            {
                                Form = ctx.TForms.FirstOrDefault(x => x.FormName == "Price Change Request"),
                                RelatedFormId = newPriceChangeRequestForm.RecordId,
                                User = requestedUser
                            };

                            ctx.UserRequests.Add(uR);
                        }

                        ctx.SaveChanges();

                        formId = newPriceChangeRequestForm.RecordId;

                        Comments systemComment = new Comments
                        {
                            Form = ctx.TForms.FirstOrDefault(x => x.FormName == "Price Change Request"),
                            Note = "Request Created By: " + currentUser.DisplayName,
                            RelatedFormId = formId,
                            SystemComment = true,
                            Timestamp = DateTime.Now
                        };

                        ctx.Comments.Add(systemComment);

                        Comments systemComment2 = new Comments
                        {
                            Form = ctx.TForms.FirstOrDefault(x => x.FormName == "Price Change Request"),
                            Note = "Requested By: " + requestedUser.DisplayName,
                            RelatedFormId = formId,
                            SystemComment = true,
                            Timestamp = DateTime.Now
                        };

                        ctx.Comments.Add(systemComment2);

                        if (ddlAssignedTo.SelectedIndex != -1)
                        {
                            Comments systemComment3 = new Comments
                            {
                                Form = ctx.TForms.FirstOrDefault(x => x.FormName == "Price Change Request"),
                                Note = "Request Assigned To: " + requestedUser.DisplayName,
                                RelatedFormId = formId,
                                SystemComment = true,
                                Timestamp = DateTime.Now
                            };

                            ctx.Comments.Add(systemComment3);
                        }

                        if (txtComments.Text != "")
                        {
                            Comments firstComment = new Comments
                            {
                                Form = ctx.TForms.FirstOrDefault(x => x.FormName == "Price Change Request"),
                                Note = txtComments.Text,
                                RelatedFormId = formId,
                                SystemComment = false,
                                Timestamp = DateTime.Now,
                                User = ctx.SystemUsers.FirstOrDefault(x => x.SystemUserID == currentUser.SystemUserID),
                            };

                            ctx.Comments.Add(firstComment);
                            ctx.SaveChanges();
                        }

                        if (lblEmailsSentTo.Text != "")
                        {
                            Comments notifyComment = new Comments
                            {
                                Form = ctx.TForms.FirstOrDefault(x => x.FormName == "Price Change Request"),
                                Note = "Request Notifications Sent To: " + lblEmailsSentTo.Text,
                                RelatedFormId = formId,
                                SystemComment = true,
                                Timestamp = DateTime.Now
                            };

                            ctx.Comments.Add(notifyComment);

                            ctx.SaveChanges();

                            TForm submittedForm = ctx.TForms.FirstOrDefault(t => t.FormName == "Price Change Request");

                            SendEmail msg = new SendEmail();
                            StringBuilder bodyHtml = new StringBuilder();

                            bodyHtml.AppendLine("<div style=\"width:50%; text-align:center;\"><img src=\"http://www.wctingle.com/img/Logo.jpg\" /><br /><br />")
                                .Append("A new Price Change Request Request has been submitted.<br /><br />")
                                .AppendLine("<table style=\"border: 4px solid #d0604c;background-color:#FFF;width:100%;margin-lefT:auto; margin-right:auto;\">")
                                .AppendLine("    <tr>")
                                .AppendLine("        <td colspan=\"4\" style=\"text-align: center;vertical-align: middle;font-weight: bold;font-size: 20px;border: 4px solid #d0604c; color:#FFF; background-color:#bc4445;\">Price Change Request</td>")
                                .AppendLine("    </tr>")
                                .AppendLine("    <tr>")
                                .AppendLine("        <td style=\"text-align:right;font-size:16px;font-weight:bold;width:25%;color:#bc4445;\">Company:</td>")
                                .Append("        <td style=\"text-align:left;font-size:16px;font-weight:bold;width:25%;color:#000;\">").Append(ddlCompany.SelectedText).AppendLine("</td>")
                                .AppendLine("        <td style=\"text-align:right;font-size:16px;font-weight:bold;width:25%; color:#bc4445\"></td>")
                                .AppendLine("        <td style=\"text-align:left;font-size:16px;font-weight:bold;width:25%;color:#000\"></td>")
                                .AppendLine("    </tr>")
                                .AppendLine("    <tr>")
                                .AppendLine("        <td style=\"text-align:right;font-size:16px;font-weight:bold;width:25%;color:#bc4445;\">Customer:</td>")
                                .Append("        <td style=\"text-align:left;font-size:16px;font-weight:bold;width:25%;color:#000;\">").Append(txtCustomer.Text).AppendLine("</td>")
                                .AppendLine("        <td style=\"text-align:right;font-size:16px;font-weight:bold;width:25%;color:#bc4445;\">Line #:</td>")
                                .Append("        <td style=\"text-align:left;font-size:16px;font-weight:bold;width:25%;color:#000;\">").Append(txtLineNumber.Text).AppendLine("</td>")
                                .AppendLine("    </tr>")
                                .AppendLine("    <tr>")
                                .AppendLine("        <td style=\"text-align:right;font-size:16px;font-weight:bold;width:25%;color:#bc4445;\">Account Number:</td>")
                                .Append("        <td style=\"text-align:left;font-size:16px;font-weight:bold;width:25%;color:#000;\">").Append(txtAccountNumber.Text).AppendLine("</td>")
                                .AppendLine("        <td style=\"text-align:right;font-size:16px;font-weight:bold;width:25%;color:#bc4445;\">Product:</td>")
                                .Append("        <td style=\"text-align:left;font-size:16px;font-weight:bold;width:25%;color:#000;\">").Append(ddlProduct.SelectedText).AppendLine("</td>")

                                .AppendLine("    </tr>")
                                .AppendLine("    <tr>")
                                .AppendLine("        <td style=\"text-align:right;font-size:16px;font-weight:bold;width:25%;color:#bc4445;\">Sales Rep:</td>")
                                .Append("        <td style=\"text-align:left;font-size:16px;font-weight:bold;width:25%;color:#000;\">").Append(txtSalesRep.Text).AppendLine("</td>")
                                .AppendLine("        <td style=\"text-align:right;font-size:16px;font-weight:bold;width:25%;color:#bc4445;\">Material SKU:</td>")
                                .Append("        <td style=\"text-align:left;font-size:16px;font-weight:bold;width:25%;color:#000;\">").Append(txtSKU.Text).AppendLine("</td>")
                                .AppendLine("    </tr>")
                                .AppendLine("    <tr>")
                                .AppendLine("        <td style=\"text-align:right;font-size:16px;font-weight:bold;width:25%;color:#bc4445;\">Reference / Order #:</td>")
                                .Append("        <td style=\"text-align:left;font-size:16px;font-weight:bold;width:25%;color:#000;\">").Append(txtOrderNumber.Text).AppendLine("</td>")
                                .AppendLine("        <td style=\"text-align:right;font-size:16px;font-weight:bold;width:25%;color:#bc4445;\">Quantity:</td>")
                                .Append("        <td style=\"text-align:left;font-size:16px;font-weight:bold;width:25%;color:#000;\">").Append(txtQuantity.Text).AppendLine("</td>")

                                .AppendLine("    </tr>")
                                .AppendLine("    <tr>")
                                .AppendLine("        <td style=\"text-align:right;font-size:16px;font-weight:bold;width:25%;color:#bc4445;\">Cross Reference Old Order #:</td>")
                                .Append("        <td style=\"text-align:left;font-size:16px;font-weight:bold;width:25%;color:#000;\">").Append(txtCrossRefOldOrderNumber.Text).AppendLine("</td>")
                                .AppendLine("        <td style=\"text-align:right;font-size:16px;font-weight:bold;width:25%;color:#bc4445;\">Price:</td>")
                                .Append("        <td style=\"text-align:left;font-size:16px;font-weight:bold;width:25%;color:#000;\">").Append(txtPrice.Text).AppendLine("</td>")
                                .AppendLine("    </tr>")
                                .AppendLine("    <tr>")
                                    .AppendLine("       <td style=\"width:100%;\" colspan=\"4\">")
                                    .AppendLine("        <table style=\"border:none; width:100%\">")
                                    .AppendLine("            <tr>")
                                    .AppendLine("                <td colspan=\"4\">")
                                    .AppendLine("                    <span style=\"font-weight:bold; color:#bc4445; text-decoration:underline\">Assignment and Request Details:</span>")
                                    .AppendLine("                </td>")
                                    .AppendLine("            </tr>")
                                    .AppendLine("            <tr>")
                                    .AppendLine("                <td style=\"width:20%; text-align:right\"><span class=\"formRedText\">Requested By:</span></td>")
                                    .Append("                    <td style=\"width:25%; text-align:left\">").AppendLine(ddlRequestedBy.SelectedItem.Text)
                                    .AppendLine("                </td>")
                                    .AppendLine("                <td style=\"width:20%; text-align:right\"><span class=\"formRedText\">Assigned To:</span></td>")
                                    .Append("                   <td style=\"width:25%; text-align:left\">");

                            if (ddlAssignedTo.SelectedIndex != -1) { bodyHtml.AppendLine(ddlAssignedTo.SelectedItem.Text); } else { bodyHtml.AppendLine("N/A"); }

                            bodyHtml.AppendLine("            </td>")
                                .AppendLine("            </tr>")
                                .AppendLine("            <tr>")
                                .AppendLine("                <td style=\"width:18%; text-align:right\"><span class=\"formRedText\">Date Created:</span></td>")
                                .AppendLine("                <td style=\"width:18%; text-align:left\">")
                                .AppendLine(DateTime.Now.ToShortDateString())
                                .AppendLine("                </td>")
                                .AppendLine("                <td style=\"width:18%; text-align:right\"><span class=\"formRedText\">Due By:</span></td>")
                                .Append("                    <td style=\"width:18%; text-align:left\">").Append(txtDueByDate.Value).AppendLine("</td>")
                                .AppendLine("            </tr>")
                                .AppendLine("            <tr>")
                                .AppendLine("                <td style=\"width:10%; text-align:right\"><span class=\"formRedText\">Status:</span></td>")
                                .Append("                    <td style=\"width:10%; text-align:left\">").AppendLine(ddlStatus.SelectedText)
                                .AppendLine("                </td>")
                                .AppendLine("                <td style=\"width:10%; text-align:right\"><span class=\"formRedText\">Priority:</span></td>")
                                .Append("                    <td style=\"width:10%; text-align:left\">").AppendLine(ddlPriority.SelectedText)
                                .AppendLine("                </td>")
                                .AppendLine("            </tr>")
                                .AppendLine("        </table>")
                                .AppendLine("       </td>")
                                .AppendLine("    </tr>")
                                .AppendLine("    <tr>")
                                .Append("       <td style=\"width:100%; text-align:center\" colspan=\"4\">Created By: ").AppendLine(currentUser.DisplayName)
                                .AppendLine("       </td>")
                                .AppendLine("    </tr>")
                                .AppendLine("    <tr>")
                                .Append("           <td style=\"width:100%; text-align:center\" colspan=\"4\"><span style=\"color:#bc4445; font-weight:bold\">Request Notifications Sent To:</span> <br />")
                                .AppendLine(lblEmailsSentTo.Text)
                                .AppendLine("       </td>")
                                .AppendLine("    </tr>")
                                .AppendLine("    <tr>")
                                .AppendLine("           <td style=\"width:100%; text-align:center\" colspan=\"4\"><br /><br /></td>")
                                .AppendLine("    </tr>")
                                .AppendLine("</table><br /><br />");

                            if (cbSendComments.Checked)
                            {
                                bodyHtml.AppendLine("<div style=\"width:80%; color:#bc4445; margin: 0 auto; text-align:center;\">Comments<br /></div>")
                                    .AppendLine("<div style=\"width:80%; background-color:#bc4445; margin: 0 auto; text-align: left; padding:3px; color: white; \">")
                                    .Append(txtComments.Text).AppendLine("<br /><br />")
                                    .AppendLine("<span style=\"padding-right:15px\">").AppendLine(currentUser.DisplayName).AppendLine("</span>")
                                    .AppendLine(DateTime.Now.ToString("MMMM dd, yyyy"))
                                    .AppendLine("</div>");

                            }

                            bodyHtml.AppendLine("</div><br /><br />");

                            bool result = msg.SendMail("InfoShare@wctingle.com", emailList, "Price Change Request", bodyHtml.ToString(), submittedForm, formId, currentUser);

                            txtCustomer.Enabled = false;
                            txtLineNumber.Enabled = false;
                            txtAccountNumber.Enabled = false;
                            txtQuantity.Enabled = false;
                            txtSKU.Enabled = false;
                            txtSalesRep.Enabled = false;
                            ddlProduct.Enabled = false;
                            txtOrderNumber.Enabled = false;
                            txtPrice.Enabled = false;
                            txtCrossRefOldOrderNumber.Enabled = false;
                            ddlCompany.Enabled = false;
                            ddlRequestedBy.Enabled = false;
                            ddlAssignedTo.Enabled = false;
                            txtDueByDate.Disabled = true;
                            ddlStatus.Enabled = false;
                            ddlPriority.Enabled = false;
                            cbNotifyStandard.Enabled = false;
                            cbNotifyRequester.Enabled = false;
                            cbNotifyOther.Enabled = false;
                            cbNotifyAssignee.Enabled = false;
                            cbSendComments.Enabled = false;
                            txtComments.Enabled = false;

                            string pageUrl = Request.Url.AbsoluteUri.Substring(0, Request.Url.AbsoluteUri.Count() - Request.Url.Query.Count());
                            Response.Redirect(pageUrl + "?FormAction=add&sendEmail=" + result.ToString());
                        }
                        else
                        {
                            string pageUrl = Request.Url.AbsoluteUri.Substring(0, Request.Url.AbsoluteUri.Count() - Request.Url.Query.Count());
                            Response.Redirect(pageUrl + "?FormAction=add&sendEmail=NotRequired");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                pnlCompleted.Visible = true;
                pnlForm.Visible = false;
                lblMessage.Text = "An error occured during submission of this request.  <br /><br />It is possible that the form was completed before this error occurred, <br />so please contact your System Administrator before re-submitting.";
            }
        }

        protected void ddlRequestedBy_DataBound(object sender, EventArgs e)
        {
            UserLogic newLogic = new UserLogic();

            System.Security.Principal.IPrincipal user = System.Web.HttpContext.Current.User;
            SystemUsers currentUser = newLogic.GetCurrentUser(user);

            if (Request.IsAuthenticated)
            {
                ddlRequestedBy.SelectedValue = currentUser.SystemUserID.ToString();
                lblNotifyRequesterValue.Text = ddlRequestedBy.SelectedItem.Text;
            }
            else
            {
                Response.Redirect("/default", true);
            }
        }

        protected void ddlRequestedBy_SelectedIndexChanged(object sender, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
        {
            FillEmailAddressLabels();
        }

        protected void ddlAssignedTo_SelectedIndexChanged(object sender, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
        {
            FillEmailAddressLabels();
        }

        protected void ddlNotifyOther_SelectedIndexChanged(object sender, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
        {
            FillEmailAddressLabels();
        }

        protected void cbNotifyStandard_CheckedChanged(object sender, EventArgs e)
        {
            FillEmailAddressLabels();
        }

        protected void cbNotifyAssignee_CheckedChanged(object sender, EventArgs e)
        {
            FillEmailAddressLabels();
        }

        protected void cbNotifyOther_CheckedChanged(object sender, EventArgs e)
        {
            FillEmailAddressLabels();
        }

        protected void cbNotifyRequester_CheckedChanged(object sender, EventArgs e)
        {
            FillEmailAddressLabels();
        }

        protected void ddlCompany_SelectedIndexChanged(object sender, EventArgs e)
        {
            FillEmailAddressLabels();
        }

        protected void btnInsertEmail_Click(object sender, EventArgs e)
        {
            try
            {
                using (FormContext ctx = new FormContext())
                {
                    if (!ctx.NotificationEmailAddresses.Any(x => x.Name == txtNameInsert.Text || x.Address == txtAddressInsert.Text))
                    {
                        if (!ctx.SystemUsers.Any(x => x.EmailAddress == txtAddressInsert.Text))
                        {
                            NotificationEmailAddress newEmail = new NotificationEmailAddress();

                            newEmail.Timestamp = DateTime.Now;
                            newEmail.Name = txtNameInsert.Text;
                            newEmail.Address = txtAddressInsert.Text;
                            newEmail.Status = Convert.ToInt16(rblNotificationEmailStatusInsert.SelectedValue);

                            ctx.NotificationEmailAddresses.Add(newEmail);

                            ctx.SaveChanges();

                            lblInsertEmailMessage.Text = "";
                            txtAddressInsert.Text = "";
                            txtNameInsert.Text = "";
                            rblNotificationEmailStatusInsert.SelectedIndex = 0;
                            ddlNotifyOther.DataBind();
                        }
                        else
                        {
                            lblInsertEmailMessage.Text = "A System User already exists with this Email Address.  Please enter a unique Email Address.";
                        }
                    }
                    else
                    {
                        if (ctx.NotificationEmailAddresses.Any(x => x.Name == txtNameInsert.Text && x.Address == txtAddressInsert.Text))
                        {
                            lblInsertEmailMessage.Text = "A Notification Email already exists with this Name and Email Address.  Please enter a unique Name and Email Address.";
                        }
                        else if (ctx.NotificationEmailAddresses.Any(x => x.Name == txtNameInsert.Text))
                        {
                            lblInsertEmailMessage.Text = "A Notification Email already exists with this Name.  Please enter a unique Name.";
                        }
                        else if (ctx.NotificationEmailAddresses.Any(x => x.Address == txtAddressInsert.Text))
                        {
                            lblInsertEmailMessage.Text = "A Notification Email already exists with this Email Address.  Please enter a unique Email Address.";
                        }

                    }
                }
            }
            catch (Exception ex)
            {
                lblInsertEmailMessage.Text = "Unable to add this Email Address.  Please contact your system administrator.";
            }
        }

        protected void ddlNotifyOther_TextChanged(object sender, EventArgs e)
        {
            FillEmailAddressLabels();
        }

        protected void ddlNotifyOther_ItemChecked(object sender, Telerik.Web.UI.RadComboBoxItemEventArgs e)
        {
            FillEmailAddressLabels();
            ddlNotifyOther.OpenDropDownOnLoad = true;
        }

        protected void ddlNotifyOther_CheckAllCheck(object sender, Telerik.Web.UI.RadComboBoxCheckAllCheckEventArgs e)
        {
            FillEmailAddressLabels();
            ddlNotifyOther.OpenDropDownOnLoad = true;

        }

        protected void ddlPriority_DataBound(object sender, EventArgs e)
        {
            ddlPriority.SelectedText = "Normal";
        }

        protected void cvRequestedBy_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if (ddlRequestedBy.FindItemByText(ddlRequestedBy.Text) != null)
            {
                args.IsValid = true;
            }
            else
            {
                args.IsValid = false;
            }
        }

        protected void cvAssignedTo_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if (ddlAssignedTo.FindItemByText(ddlAssignedTo.Text) != null)
            {
                args.IsValid = true;
            }
            else
            {
                args.IsValid = false;
            }
        }
    }
}