﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ReportDirectOrder.aspx.cs" Inherits="Tingle_WebForms.ReportDirectOrder" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="FeaturedContent" runat="server">
    <script>
        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);

        function BeginRequestHandler(sender, args) {
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            setTimeout(function () {
                if (prm.get_isInAsyncPostBack()) {
                    document.body.style.overflow = 'hidden';
                    jQuery("#loadingDiv").css("display", "block");
                    jQuery("#loadingGif").css("display", "block");
                }
            }, 300);
        }

        function EndRequestHandler(sender, args) {
            document.body.style.overflow = 'scroll';
            jQuery("#loadingDiv").css("display", "none");
            jQuery("#loadingGif").css("display", "none");
        }
    </script>
    <script type="text/javascript">
        function BindEvents() {
            jQuery(document).ready(function () {
                WireUpFormFields();
            });
        }

        function WireUpFormFields() {
            $("#<%= txtToDate.ClientID %>").datepicker({ dateFormat: "mm/dd/yy" });
            $("#<%= txtFromDate.ClientID %>").datepicker({ dateFormat: "mm/dd/yy" });
            $("#<%= txtInstallFrom.ClientID %>").datepicker({ dateFormat: "mm/dd/yy" });
            $("#<%= txtInstallTo.ClientID %>").datepicker({ dateFormat: "mm/dd/yy" });
            $("#MainContent_fvReport_txtInstallDateEdit").datepicker({ dateFormat: "mm/dd/yy" });
            $("#<%= txtDueByDateFrom.ClientID %>").datepicker({ dateFormat: "mm/dd/yy" });
            $("#<%= txtDueByDateTo.ClientID %>").datepicker({ dateFormat: "mm/dd/yy" });
            $("#MainContent_fvReport_txtDueByDateEdit").datepicker({ dateFormat: "mm/dd/yy" });
            
    }

    </script>
    <script type="text/javascript">
        function ClearBox(sender, args) {
            sender.clearSelection();
            sender.set_text("");
            sender.setAllItemsVisible(true);
            var input = sender.get_inputDomElement();
            input.focus();
        }

        function ComboBoxBlur(sender, args) {
            var box = sender;
            if (box.get_checkedItems().length > 0)
                sender.set_text(box.get_checkedItems().length.toString() + " Email(s) Selected");
        }

        function ComboBoxFocus(sender, args) {
            sender.set_text("");
        }

        function ShowAddNewEmailTd(sender, args) {
            jQuery("#divAddNewEmail").css("display", "block");
        }

        function CancelNewEmail(sender, args) {
            jQuery("#MainContent_fvReport_txtNameInsert").text("");
            jQuery("#MainContent_fvReport_txtAddressInsert").text("");
            jQuery("#divAddNewEmail").css("display", "none");
        }

        function CancelNewSku(sender, args) {
            jQuery("#txtMaterialSku").text("");
            jQuery("#txtQuantityOrdered").text("");
            jQuery("#divAddNewSkuQuantity").css("display", "none");
        }

        function ShowAddNewSkuQuantity(sender, args) {
            jQuery("#divAddNewSkuQuantity").css("display", "block");
        }


    </script>

</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" runat="server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
        <ContentTemplate>
            <div class="divcenter">
                <script type="text/javascript">
                    Sys.Application.add_load(BindEvents);
                </script>
                <asp:Panel ID="pnlFilter" runat="server">
                    <asp:HiddenField runat="server" ID="hfCreatedById" />
                    <table>
                        <tr class="trheader">
                            <td colspan="4" class="tdheader">
                                <div style="float: left; width: 25%">
                                    <telerik:RadDropDownList runat="server" ID="ddlCompany" AutoPostBack="true" CausesValidation="false" Width="110px" Skin="Default">
                                        <Items>
                                            <telerik:DropDownListItem Text="Any Company" Value="Any Company" />
                                            <telerik:DropDownListItem Text="Tingle" Value="Tingle" />
                                            <telerik:DropDownListItem Text="Summit" Value="Summit" />
                                        </Items>
                                    </telerik:RadDropDownList>
                                </div>
                                <div style="float: left; width: 50%">
                                    Direct Order Requests
                                </div>
                                <div style="float: left; width: 25%">
                                    <telerik:RadDropDownList runat="server" ID="ddlGlobalStatus" AutoPostBack="true" CausesValidation="false"
                                        Width="75px" Skin="Default">
                                        <Items>
                                            <telerik:DropDownListItem Text="Active" Value="Active" />
                                            <telerik:DropDownListItem Text="Archive" Value="Archive" />
                                            <telerik:DropDownListItem Text="All" Value="All" />
                                        </Items>
                                    </telerik:RadDropDownList>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4">
                                <asp:LinkButton runat="server" ID="btnAdvancedSearch" Text="Click for Advanced Search" OnClick="btnAdvancedSearch_Click"></asp:LinkButton>
                                <asp:LinkButton runat="server" ID="btnBasicSearch" Text="Click for Basic Search" Visible="false" OnClick="btnBasicSearch_Click"></asp:LinkButton>
                        </tr>
                        <tr>
                            <td class="tdcenter" colspan="2">Submission Date Range:</td>
                            <td colspan="2" class="tdleft">From:
                                <asp:TextBox ID="txtFromDate" runat="server" Width="100" AutoPostBack="true" />
                                To:
                                <asp:TextBox ID="txtToDate" runat="server" Width="100" AutoPostBack="true" /></td>
                        </tr>
                        <tr>
                            <td class="tdright">Requested By:</td>
                            <td class="tdleft">
                                <telerik:RadComboBox runat="server" ID="ddlRequestedBy" DataTextField="EmailAddress" DataValueField="SystemUserId" Height="250px" Width="175px" AutoPostBack="true"
                                    DropDownWidth="300px" ItemType="Tingle_WebForms.Models.SystemUsers" Skin="Default" SelectMethod="GetUsers"
                                    EmptyMessage="Type to Filter" AllowCustomText="true" Filter="Contains" MarkFirstMatch="true" CausesValidation="false">
                                    <ItemTemplate>
                                        <%# Eval("DisplayName") %> -- <%# Eval("EmailAddress") %>
                                    </ItemTemplate>
                                </telerik:RadComboBox>
                            </td>
                            <td class="tdright">Assigned To:</td>
                            <td class="tdleft">
                                <telerik:RadComboBox runat="server" ID="ddlAssignedTo" DataTextField="EmailAddress" DataValueField="SystemUserId" Height="250px" Width="175px" AutoPostBack="true"
                                    DropDownWidth="300px" ItemType="Tingle_WebForms.Models.SystemUsers" Skin="Default" SelectMethod="GetUsers"
                                    EmptyMessage="Type to Filter" AllowCustomText="true" Filter="Contains" MarkFirstMatch="true" CausesValidation="false">
                                    <ItemTemplate>
                                        <%# Eval("DisplayName") %> -- <%# Eval("EmailAddress") %>
                                    </ItemTemplate>
                                </telerik:RadComboBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="tdheader" colspan="4"></td>
                        </tr>
                        <tr>
                            <td class="tdright">Customer:</td>
                            <td class="tdleft">
                                <asp:TextBox ID="txtCustomer" runat="server" AutoPostBack="true"></asp:TextBox>
                            </td>
                            <td class="tdright">Material SKU#:</td>
                            <td class="tdleft">
                                <asp:TextBox ID="txtMaterialSku" runat="server" AutoPostBack="true"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="tdright" colspan="2">Status:</td>
                            <td class="tdleft" colspan="2">
                                <telerik:RadDropDownList ID="ddlStatus" runat="server" SelectMethod="GetStatuses" Skin="Default" AutoPostBack="true"
                                    CausesValidation="false" DataTextField="StatusText" DataValueField="StatusID"
                                    DefaultMessage="Any Status">
                                </telerik:RadDropDownList>
                            </td>
                        </tr>
                        <tr runat="server" id="tr1" visible="false">
                            <td class="tdright">Expedite Code:</td>
                            <td class="tdleft">
                                <telerik:RadDropDownList ID="ddlExpediteCode" runat="server" SelectMethod="GetExpediteCodes" Skin="Default" AutoPostBack="true"
                                    CausesValidation="false" DataTextField="Code" DataValueField="ExpediteCodeID"
                                    DefaultMessage="Any Code">
                                </telerik:RadDropDownList>
                            </td>
                            <td class="tdright">Account Number:</td>
                            <td class="tdleft">
                                <asp:TextBox ID="txtAccountNumber" runat="server" AutoPostBack="true" MaxLength="6"></asp:TextBox></td>
                        </tr>
                        <tr runat="server" id="tr2" visible="false">
                            <td class="tdright">Contact Name:</td>
                            <td class="tdleft">
                                <asp:TextBox ID="txtContactName" runat="server" AutoPostBack="true"></asp:TextBox></td>
                            <td class="tdright">Phone Number:</td>
                            <td class="tdleft">
                                <asp:TextBox ID="txtPhoneNumber" runat="server" AutoPostBack="true"></asp:TextBox></td>
                        </tr>
                        <tr runat="server" id="tr3" visible="false">
                            <td class="tdright">Purchase Order #:</td>
                            <td class="tdleft">
                                <asp:TextBox ID="txtPurchaseOrderNumber" runat="server" AutoPostBack="true"></asp:TextBox></td>
                            <td class="tdright">Quantity Ordered:</td>
                            <td class="tdleft">
                                <asp:TextBox ID="txtQuantityOrdered" runat="server" AutoPostBack="true"></asp:TextBox></td>
                        </tr>
                        <tr runat="server" id="tr4" visible="false">
                            <td class="tdright">OOW Order Number:</td>
                            <td class="tdleft">
                                <asp:TextBox ID="txtOowOrderNumber" runat="server" AutoPostBack="true"></asp:TextBox></td>
                            <td class="tdright">S/M:</td>
                            <td class="tdleft">
                                <asp:TextBox ID="txtSM" runat="server" AutoPostBack="true"></asp:TextBox></td>
                        </tr>
                        <tr runat="server" id="tr5" visible="false">
                            <td class="tdright">Ship Via:</td>
                            <td class="tdleft">
                                <asp:TextBox ID="txtShipVia" runat="server" AutoPostBack="true"></asp:TextBox></td>
                            <td class="tdright">Reserve:</td>
                            <td class="tdleft">
                                <asp:TextBox ID="txtReserve" runat="server" AutoPostBack="true"></asp:TextBox></td>
                        </tr>
                        <tr runat="server" id="tr6" visible="false">
                            <td class="tdcenter" colspan="2">Install Date Range:</td>
                            <td colspan="2" class="tdleft">From:
                                <asp:TextBox type="text" ID="txtInstallFrom" size="20" runat="server" Style="width: 100px;" AutoPostBack="true" />
                                To:
                                <asp:TextBox type="text" ID="txtInstallTo" size="20" runat="server" Style="width: 100px;" AutoPostBack="true" /></td>
                        </tr>
                        <tr runat="server" id="tr7" visible="false">
                            <td class="tdsectionheader" colspan="4">Ship To </td>
                        </tr>
                        <tr runat="server" id="tr8" visible="false">
                            <td class="tdright">Name:</td>
                            <td class="tdleft">
                                <asp:TextBox ID="txtShipToName" runat="server" AutoPostBack="true"></asp:TextBox></td>
                            <td class="tdright">Street Address:</td>
                            <td class="tdleft">
                                <asp:TextBox ID="txtShipToAddress" runat="server" AutoPostBack="true"></asp:TextBox></td>
                        </tr>
                        <tr runat="server" id="tr9" visible="false">
                            <td class="tdright">City:</td>
                            <td class="tdleft">
                                <asp:TextBox ID="txtShipToCity" runat="server" AutoPostBack="true"></asp:TextBox></td>
                            <td class="tdright">State:</td>
                            <td class="tdleft">
                                <asp:TextBox ID="txtShipToState" runat="server" AutoPostBack="true"></asp:TextBox></td>
                        </tr>
                        <tr runat="server" id="tr10" visible="false">
                            <td class="tdright">Zip:</td>
                            <td class="tdleft">
                                <asp:TextBox ID="txtShipToZip" runat="server" AutoPostBack="true"></asp:TextBox></td>
                            <td class="tdright">Phone:</td>
                            <td class="tdleft">
                                <asp:TextBox ID="txtShipToPhone" runat="server"></asp:TextBox></td>
                        </tr>
                        <tr runat="server" id="tr11" visible="false">
                            <td class="tdright">Due By:</td>
                            <td class="tdleft">
                                <table style="border: none;">
                                    <tr>
                                        <td style="width: 25%" class="tdright">From:</td>
                                        <td style="width: 75%" class="tdleft">
                                            <asp:TextBox runat="server" ID="txtDueByDateFrom" size="20" Style="width: 100px;" AutoPostBack="true"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 25%" class="tdright">To:</td>
                                        <td style="width: 75%" class="tdleft">
                                            <asp:TextBox runat="server" ID="txtDueByDateTo" size="20" Style="width: 100px;" AutoPostBack="true"></asp:TextBox>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td class="tdright">Priority:</td>
                            <td class="tdleft">
                                <telerik:RadDropDownList ID="ddlPriority" Skin="Default" Width="100px" runat="server" CausesValidation="false"
                                    DefaultMessage="Any Priority" AutoPostBack="true" SelectMethod="GetPriorities" DataTextField="PriorityText" DataValueField="RecordId">
                                </telerik:RadDropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" class="tdcenter">
                                <br />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" class="tdcenter">
                                <asp:LinkButton runat="server" ID="btnApplyFilters" CssClass="normalButton" Text="Apply Filters" AutoPostBack="true"></asp:LinkButton>
                                <asp:LinkButton runat="server" ID="btnResetFilters" CssClass="normalButton" Text="Reset Filters" AutoPostBack="true" OnClick="btnResetFilters_Click"></asp:LinkButton>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                <asp:Panel runat="server" ID="pnlReport">
                    <table>
                        <tr>
                            <td>
                                <asp:GridView ID="gvReport" runat="server" AllowSorting="True" AutoGenerateColumns="False"
                                    ItemType="Tingle_WebForms.Models.DirectOrderForm" SelectMethod="GetDirectOrderForms" CellPadding="4" ForeColor="#BC4445" GridLines="Horizontal"
                                    AllowPaging="True" DataKeyNames="RecordId" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px"
                                    OnRowCommand="gvReport_RowCommand" OnRowDataBound="gvReport_RowDataBound">
                                    <PagerSettings FirstPageText="First" LastPageText="Last" Mode="NumericFirstLast" PageButtonCount="10" Position="Bottom" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="ID" Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lblRecordId" runat="server" Text='<%#: Item.RecordId %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle Width="10%" />
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="Timestamp" ItemStyle-Width="15%" HeaderText="Submission Date" SortExpression="Timestamp" DataFormatString="{0:d}" HtmlEncode="false" />
                                        <asp:TemplateField HeaderText="Requested By">
                                            <ItemTemplate>
                                                <asp:Label ID="lblRequestedByUser" runat="server" Text='<%#: Item.RequestedUser.DisplayName %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle Width="15%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Customer" SortExpression="Customer">
                                            <ItemTemplate>
                                                <asp:Label ID="lblCustomer" runat="server" Text='<%#: Item.Customer %>'></asp:Label>
                                                <telerik:RadToolTip runat="server" ID="ttCustomer" Position="TopRight" RelativeTo="Element" TargetControlID="lblCustomer" ShowEvent="OnMouseOver"
                                                    Animation="Resize" RenderInPageRoot="false" AnimationDuration="500" HideEvent="LeaveTargetAndToolTip" HideDelay="100" AutoCloseDelay="20000">
                                                </telerik:RadToolTip>
                                            </ItemTemplate>
                                            <ItemStyle Width="10%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="SKU/Quantity">
                                            <ItemTemplate>
                                                <asp:Literal runat="server" ID="ltlSkuQuantity"></asp:Literal>
                                            </ItemTemplate>
                                            <ItemStyle Width="30%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Assigned User">
                                            <ItemTemplate>
                                                <asp:Label ID="lblAssignedUser" runat="server" Text='<%#: Item.AssignedUser != null ? Item.AssignedUser.DisplayName : "Unassigned" %>' ToolTip='<%#: Item.AssignedUser != null ? Item.AssignedUser.EmailAddress : "Unassigned" %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle Width="15%" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Status">
                                            <ItemTemplate>
                                                <asp:Label ID="lblStatus" runat="server" Text='<%#: Item.Status.StatusText %>' ToolTip='<%#: Item.Status.StatusText %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle Width="15%" />
                                        </asp:TemplateField>
                                        <asp:CommandField ShowSelectButton="True" SelectText="Details" ShowHeader="True" HeaderText="Details"></asp:CommandField>
                                    </Columns>
                                    <EmptyDataTemplate>No results were found matching your selection.</EmptyDataTemplate>
                                    <FooterStyle BackColor="white" ForeColor="Black" />
                                    <HeaderStyle BackColor="#bc4445" Font-Bold="True" ForeColor="White" />
                                    <PagerSettings Mode="NumericFirstLast" />
                                    <PagerStyle BackColor="#bc4445" ForeColor="Black" HorizontalAlign="Center" />
                                    <SelectedRowStyle BackColor="#999999" Font-Bold="True" ForeColor="#FFFFFF" />
                                    <SortedAscendingCellStyle BackColor="#F7F7F7" />
                                    <SortedAscendingHeaderStyle BackColor="#4B4B4B" />
                                    <SortedDescendingCellStyle BackColor="#E5E5E5" />
                                    <SortedDescendingHeaderStyle BackColor="#242121" />
                                </asp:GridView>
                            </td>
                        </tr>
                    </table>

                </asp:Panel>
                <asp:Panel ID="pnlDetails" runat="server" Visible="false">
                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" DisplayMode="BulletList" HeaderText="There are errors in the form:" Font-Size="14px" ForeColor="Red" />
                            <asp:FormView ID="fvReport" runat="server" ItemType="Tingle_WebForms.Models.DirectOrderForm" SelectMethod="GetFormDetails" OnDataBinding="fvReport_DataBinding"
                                BackColor="White" BorderStyle="None" DataKeyNames="RecordId" DefaultMode="Edit" UpdateMethod="UpdateForm" OnDataBound="fvReport_DataBound" OnPreRender="fvReport_PreRender"
                                OnItemUpdating="fvReport_ItemUpdating">
                                <EditItemTemplate>
                                    <asp:PlaceHolder runat="server" ID="phFVDetails">

                                        <asp:Label ID="lblFVMessage" runat="server" Text="" Visible="true" ForeColor="#bc4445"></asp:Label>
                                        <br />
                                        <br />
                                        <table>
                                            <tr class="trheader">
                                                <td colspan="4" class="tdheader">Direct Order Request Details</td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class="tdcenter">Request ID:
                                <asp:Label ID="lblRecordId" runat="server" Text='<%#: Eval("RecordId") %>'></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td class="tdright">Company:</td>
                                                <td class="tdleft">
                                                    <asp:Label runat="server" ID="lblCompanyEdit" Visible="false" Text='<%# Bind("Company") %>'></asp:Label>
                                                    <telerik:RadDropDownList runat="server" ID="ddlCompanyEdit" AutoPostBack="true" CausesValidation="false" OnSelectedIndexChanged="ddlCompanyEdit_SelectedIndexChanged"
                                                        Width="75px" Skin="Default" OnDataBinding="ddlCompanyEdit_DataBinding">
                                                        <Items>
                                                            <telerik:DropDownListItem Text="Tingle" Value="Tingle" />
                                                            <telerik:DropDownListItem Text="Summit" Value="Summit" />
                                                        </Items>
                                                    </telerik:RadDropDownList>
                                                </td>
                                                <td class="tdright"></td>
                                                <td class="tdleft"></td>
                                            </tr>
                                            <tr>
                                                <td class="tdright">
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Customer field is required."
                                                        ControlToValidate="txtCustomerEdit" ForeColor="Red" Display="None"></asp:RequiredFieldValidator>Customer:</td>
                                                <td class="tdleft">
                                                    <asp:TextBox ID="txtCustomerEdit" runat="server" Text='<%# Bind("Customer") %>'></asp:TextBox><br />

                                                </td>
                                                <td class="tdright">
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="Expedite Code field is required."
                                                        ControlToValidate="ddlExpediteCodeEdit" InitialValue="0" ForeColor="Red" Display="None"></asp:RequiredFieldValidator>Expedite Code:</td>
                                                <td class="tdleft">
                                                    <telerik:RadDropDownList ID="ddlExpediteCodeEdit" runat="server" SelectMethod="GetExpediteCodes" Skin="Default" AutoPostBack="false"
                                                        CausesValidation="false" DataTextField="Code" DataValueField="ExpediteCodeID" OnDataBinding="ddlExpediteCodeEdit_DataBinding"
                                                        DefaultMessage="Any Code">
                                                    </telerik:RadDropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="tdright">
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Contact Name field is required."
                                                        ControlToValidate="txtContactNameEdit" ForeColor="Red" Display="None"></asp:RequiredFieldValidator>Contact Name:</td>
                                                <td class="tdleft">
                                                    <asp:TextBox ID="txtContactNameEdit" runat="server" Text='<%# Bind("ContactName") %>'></asp:TextBox></td>
                                                <td class="tdright">
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="Phone Number field is required."
                                                        ControlToValidate="txtPhoneNumberEdit" ForeColor="Red" Display="None"></asp:RequiredFieldValidator>Phone Number:</td>
                                                <td class="tdleft">
                                                    <asp:TextBox ID="txtPhoneNumberEdit" runat="server" Text='<%# Bind("PhoneNumber") %>'></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class="tdcenter">Add New Material SKU# and Quantity
                                <telerik:RadButton ID="btnShowNewSKUDiv" runat="server" Text="Add New Material SKU And Quantity" ButtonType="SkinnedButton"
                                    CssClass="plusSignImageBtn" CausesValidation="false" AutoPostBack="false" OnClientClicked="ShowAddNewSkuQuantity" ToolTip="Add New Material SKU And Quantity">
                                    <Image EnableImageButton="true" />
                                </telerik:RadButton>
                                                </td>
                                            </tr>
                                            <tr runat="server">
                                                <td colspan="4">
                                                    <div style="width: 80%; border: 0; margin: 0 auto; display: none; text-align: center" id="divAddNewSkuQuantity">
                                                        <table style="border: 1px solid #000; border-radius: 5px;">
                                                            <tr>
                                                                <td class="tdcenter">Material SKU#:</td>
                                                                <td>
                                                                    <telerik:RadTextBox ID="txtMaterialSkuInsert" runat="server" Text="" Width="150px"></telerik:RadTextBox>
                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="*" Text="*" ForeColor="Red" ValidationGroup="SkuQuantityInsert"
                                                                        ControlToValidate="txtMaterialSkuInsert"></asp:RequiredFieldValidator>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="tdcenter">Quantity:</td>
                                                                <td>
                                                                    <telerik:RadTextBox ID="txtQuantityOrderedInsert" runat="server" Text="" Width="150px"></telerik:RadTextBox>
                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ErrorMessage="*" Text="*" ForeColor="Red" ValidationGroup="SkuQuantityInsert"
                                                                        ControlToValidate="txtQuantityOrderedInsert"></asp:RequiredFieldValidator>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <telerik:RadButton ID="btnAddSkuQuantity" runat="server" Text="Add SKU" OnClick="btnAddSkuQuantity_Click" ValidationGroup="SkuQuantityInsert"></telerik:RadButton>
                                                                    <telerik:RadButton runat="server" ID="btnCancelSkuQuantity" Text="Cancel" OnClientClicked="CancelNewSku" CausesValidation="false"></telerik:RadButton>
                                                                    <br />
                                                                    <asp:Label runat="server" ID="lblAddSkuMessage" Text=""></asp:Label>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="4">
                                                    <asp:GridView ID="gvSkus" runat="server" AllowSorting="True" AutoGenerateColumns="False" Width="70%" Style="margin: 0 auto !important"
                                                        ItemType="Tingle_WebForms.Models.SkuQuantity" SelectMethod="GetSkuQuantities" CellPadding="4" ForeColor="#000000" GridLines="Horizontal"
                                                        AllowPaging="True" DataKeyNames="RecordId" BackColor="White" BorderColor="#000000" BorderStyle="Solid" BorderWidth="1px"
                                                        DeleteMethod="gvSkus_DeleteItem" UpdateMethod="gvSkus_UpdateItem" OnRowUpdating="gvSkus_RowUpdating">
                                                        <PagerSettings FirstPageText="First" LastPageText="Last" Mode="NumericFirstLast" PageButtonCount="10" Position="Bottom" />
                                                        <Columns>
                                                            <asp:TemplateField HeaderText="ID" Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblRecordId" runat="server" Visible="false" Text='<%#: Eval("RecordId") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:Label ID="lblRecordIdEdit" runat="server" Visible="false" Text='<%#: Eval("RecordId") %>'></asp:Label>
                                                                </EditItemTemplate>
                                                                <ItemStyle Width="1%" />
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="MaterialSku">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblMaterialSku" runat="server" Text='<%#: Eval("MaterialSku") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:TextBox runat="server" ID="txtMaterialSkuEdit" Text='<%# Eval("MaterialSku") %>' MaxLength="100"></asp:TextBox>
                                                                    <asp:RequiredFieldValidator ID="rfvTxtMaterialSkuEdit" runat="server" ErrorMessage="*" Text="*" ControlToValidate="txtMaterialSkuEdit"
                                                                        ForeColor="Red" Font-Size="16px" ValidationGroup="AddNewSku"></asp:RequiredFieldValidator>
                                                                </EditItemTemplate>
                                                                <ItemStyle Width="35%" />
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Quantity">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblQuantity" runat="server" Text='<%#: Eval("Quantity") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:TextBox runat="server" ID="txtQuantityEdit" Text='<%# Eval("Quantity") %>' MaxLength="100"></asp:TextBox>
                                                                    <asp:RequiredFieldValidator ID="rfvTxtQuantityEdit" runat="server" ErrorMessage="*" Text="*" ControlToValidate="txtQuantityEdit"
                                                                        ForeColor="Red" Font-Size="16px" ValidationGroup="AddNewSku"></asp:RequiredFieldValidator>
                                                                </EditItemTemplate>
                                                                <ItemStyle Width="35%" />
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Completed">
                                                                <ItemTemplate>
                                                                    <asp:CheckBox runat="server" ID="cbCompleted" Text="" Checked='<%# (Boolean)Eval("Completed") %>' BorderStyle="None" Enabled="false" />
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:CheckBox runat="server" ID="cbCompletedEdit" Text="" Checked='<%# (Boolean)Eval("Completed") %>' BorderStyle="None" CausesValidation="false" />
                                                                </EditItemTemplate>
                                                                <ItemStyle Width="35%" />
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="TempId" Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblTempId" runat="server" Text='<%#: Eval("TempId") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:Label ID="lblTempIdEdit" runat="server" Text='<%#: Eval("TempId") %>'></asp:Label>
                                                                </EditItemTemplate>
                                                                <ItemStyle Width="1%" />
                                                            </asp:TemplateField>
                                                            <asp:CommandField ShowEditButton="True" EditText="Edit" ShowHeader="True" HeaderText="Edit" ValidationGroup="AddNewSku"></asp:CommandField>
                                                            <asp:TemplateField HeaderText="Delete">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton ID="lbDeleteCode" runat="server" Text="Delete" CommandName="Delete" CausesValidation="false" ForeColor="Black"
                                                                        OnClientClick="return confirm('Are you sure you want to delete this Material SKU?')" />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                        <EmptyDataTemplate>Please add at least one SKU# and Quantity.</EmptyDataTemplate>
                                                        <FooterStyle BackColor="white" ForeColor="Black" />
                                                        <HeaderStyle BackColor="#bc4445" Font-Bold="True" ForeColor="White" />
                                                        <PagerSettings Mode="NumericFirstLast" />
                                                        <PagerStyle BackColor="#bc4445" ForeColor="Black" HorizontalAlign="Center" />
                                                        <SelectedRowStyle BackColor="#999999" Font-Bold="True" ForeColor="#FFFFFF" />
                                                        <SortedAscendingCellStyle BackColor="#F7F7F7" />
                                                        <SortedAscendingHeaderStyle BackColor="#4B4B4B" />
                                                        <SortedDescendingCellStyle BackColor="#E5E5E5" />
                                                        <SortedDescendingHeaderStyle BackColor="#242121" />
                                                    </asp:GridView>
                                                    <br />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="tdright">
                                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="Account Number must be a numeric value between 0 and 999999."
                                                        ControlToValidate="txtAccountNumberEdit" Font-Size="12px" ValidationExpression="^\d+$"
                                                        SetFocusOnError="true" Display="None"></asp:RegularExpressionValidator>Account Number:</td>
                                                <td class="tdleft">
                                                    <asp:TextBox ID="txtAccountNumberEdit" runat="server" Text='<%# Bind("AccountNumber") %>'></asp:TextBox></td>
                                                <td class="tdright">Purchase Order #:</td>
                                                <td class="tdleft">
                                                    <asp:TextBox ID="txtPurchaseOrderNumberEdit" runat="server" Text='<%# Bind("PurchaseOrderNumber") %>'></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td class="tdright">OOW Order Number:</td>
                                                <td class="tdleft">
                                                    <asp:TextBox ID="txtOowOrderNumberEdit" runat="server" Text='<%# Bind("OowOrderNumber") %>'></asp:TextBox></td>
                                                <td class="tdright">S/M:</td>
                                                <td class="tdleft">
                                                    <asp:TextBox ID="txtSMEdit" runat="server" Text='<%# Bind("SM") %>'></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td class="tdright">Ship Via:</td>
                                                <td class="tdleft">
                                                    <asp:TextBox ID="txtShipViaEdit" runat="server" Text='<%# Bind("ShipVia") %>'></asp:TextBox></td>
                                                <td class="tdright">Reserve:</td>
                                                <td class="tdleft">
                                                    <asp:TextBox ID="txtReserveEdit" runat="server" Text='<%# Bind("Reserve") %>'></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td class="tdright">Install Date:</td>
                                                <td class="tdleft">
                                                    <input type="text" id="txtInstallDateEdit" runat="server" value='<%# Eval("InstallDate") != null ? ((DateTime)Eval("InstallDate")).ToShortDateString() : ""  %>' /></td>
                                                <td class="tdright"></td>
                                                <td class="tdleft"></td>
                                            </tr>
                                            <tr>
                                                <td class="tdsectionheader" colspan="4">Ship To (If different than default)</td>
                                            </tr>
                                            <tr>
                                                <td class="tdright">Name:</td>
                                                <td class="tdleft">
                                                    <asp:TextBox ID="txtShipToNameEdit" runat="server" Text='<%# Bind("ShipToName") %>'></asp:TextBox></td>
                                                <td class="tdright">Sreet Address:</td>
                                                <td class="tdleft">
                                                    <asp:TextBox ID="txtShipToAddressEdit" runat="server" Text='<%# Bind("ShipToAddress") %>'></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td class="tdright">City:</td>
                                                <td class="tdleft">
                                                    <asp:TextBox ID="txtShipToCityEdit" runat="server" Text='<%# Bind("ShipToCity") %>'></asp:TextBox></td>
                                                <td class="tdright">State:</td>
                                                <td class="tdleft">
                                                    <asp:TextBox ID="txtShipToStateEdit" runat="server" Text='<%# Bind("ShipToState") %>'></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td class="tdright">Zip:</td>
                                                <td class="tdleft">
                                                    <asp:TextBox ID="txtShipToZipEdit" runat="server" Text='<%# Bind("ShipToZip") %>'></asp:TextBox></td>
                                                <td class="tdright">Phone:</td>
                                                <td class="tdleft">
                                                    <asp:TextBox ID="txtShipToPhoneEdit" runat="server" Text='<%# Bind("ShipToPhone") %>'></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td style="width: 100%;" colspan="4">
                                                    <div style="width: 80%; border: 1px solid black; border-radius: 5px; margin: 0 auto; height: 90px;">
                                                        <table style="border: none;">
                                                            <tr>
                                                                <td colspan="6">
                                                                    <span style="font-weight: bold; color: #bc4445; text-decoration: underline">Assignment and Request Details:</span>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 20%; text-align: right"><span class="formRedText">Requested By:</span></td>
                                                                <td style="width: 25%; text-align: left">
                                                                    <telerik:RadComboBox runat="server" ID="ddlRequestedByEdit" DataTextField="EmailAddress" DataValueField="SystemUserId" Height="250px" Width="175px" AutoPostBack="true"
                                                                        DropDownWidth="300px" ItemType="Tingle_WebForms.Models.SystemUsers" Skin="Default" SelectMethod="GetUsers"
                                                                        EmptyMessage="Type to Filter" AllowCustomText="true" Filter="Contains" MarkFirstMatch="true" OnDataBound="ddlRequestedByEdit_DataBound"
                                                                        OnSelectedIndexChanged="ddlRequestedByEdit_SelectedIndexChanged" CausesValidation="false">
                                                                        <ItemTemplate>
                                                                            <%# Eval("DisplayName") %> -- <%# Eval("EmailAddress") %>
                                                                        </ItemTemplate>
                                                                    </telerik:RadComboBox>
                                                                    <asp:CustomValidator ID="cvRequestedBy"
                                                                        runat="server"
                                                                        ControlToValidate="ddlRequestedByEdit"
                                                                        ErrorMessage="Requested By Field contains an invalid selection."
                                                                        ValidateEmptyText="true"
                                                                        Display="None"
                                                                        OnServerValidate="cvRequestedBy_ServerValidate"
                                                                        SetFocusOnError="true">
                                                                    </asp:CustomValidator>
                                                                </td>
                                                                <td style="width: 18%; text-align: right"><span class="formRedText">Due By:</span></td>
                                                                <td style="width: 18%; text-align: left">
                                                                    <input type="text" id="txtDueByDateEdit" runat="server" style="width: 75px;"
                                                                        value='<%# Eval("DueDate") != null ? ((DateTime)Eval("DueDate")).ToString("MM/dd/yyyy") : "" %>' /></td>
                                                                <td style="width: 10%; text-align: right"><span class="formRedText">Status:</span></td>
                                                                <td style="width: 10%; text-align: left">
                                                                    <telerik:RadDropDownList ID="ddlStatusEdit" runat="server" SelectMethod="GetStatusesEdit" OnDataBound="ddlStatusEdit_DataBound"
                                                                        AutoPostBack="false" DataTextField="StatusText" DataValueField="StatusID" Skin="Default" Width="100px">
                                                                    </telerik:RadDropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 20%; text-align: right"><span class="formRedText">Assigned To:</span></td>
                                                                <td style="width: 25%; text-align: left">
                                                                    <telerik:RadComboBox runat="server" ID="ddlAssignedToEdit" DataTextField="EmailAddress" DataValueField="SystemUserId" Height="250px" Width="175px" AutoPostBack="true"
                                                                        DropDownWidth="300px" ItemType="Tingle_WebForms.Models.SystemUsers" Skin="Default" SelectMethod="GetUsers"
                                                                        EmptyMessage="Unassigned" AllowCustomText="true" Filter="Contains" MarkFirstMatch="true" OnDataBound="ddlAssignedToEdit_DataBound"
                                                                        OnSelectedIndexChanged="ddlAssignedToEdit_SelectedIndexChanged" CausesValidation="false" DefaultMessage="Unassigned">
                                                                        <ItemTemplate>
                                                                            <%# Eval("DisplayName") %> -- <%# Eval("EmailAddress") %>
                                                                        </ItemTemplate>
                                                                    </telerik:RadComboBox>
                                                                    <asp:CustomValidator ID="cvAssignedTo"
                                                                        runat="server"
                                                                        ControlToValidate="ddlAssignedToEdit"
                                                                        ErrorMessage="Assigned To Field contains an invalid selection."
                                                                        Display="None"
                                                                        OnServerValidate="cvAssignedTo_ServerValidate"
                                                                        SetFocusOnError="true">
                                                                    </asp:CustomValidator>
                                                                </td>
                                                                <td style="width: 18%; text-align: right"><span class="formRedText">Date Created:</span></td>
                                                                <td style="width: 18%; text-align: left">
                                                                    <asp:Label runat="server" ID="lblDateCreatedEdit" Text='<%# ((DateTime)Eval("Timestamp")).ToShortDateString() %>'></asp:Label>
                                                                </td>
                                                                <td style="width: 10%; text-align: right"><span class="formRedText">Priority:</span></td>
                                                                <td style="width: 10%; text-align: left">
                                                                    <telerik:RadDropDownList ID="ddlPriorityEdit" Skin="Default" Width="100px" runat="server" CausesValidation="false"
                                                                        SelectMethod="GetPriorities" DataTextField="PriorityText" DataValueField="RecordId" AutoPostBack="false" OnDataBound="ddlPriorityEdit_DataBound">
                                                                    </telerik:RadDropDownList>
                                                                </td>

                                                            </tr>
                                                        </table>
                                                    </div>
                                                    <div style="width: 80%; border: 1px solid black; border-radius: 5px; margin: 0 auto; height: 90px;">
                                                        <table style="border: none;">
                                                            <tr>
                                                                <td colspan="6">
                                                                    <span style="font-weight: bold; color: #bc4445; text-decoration: underline">Notification Details:</span>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 17%; text-align: left; vertical-align: middle">
                                                                    <asp:CheckBox runat="server" ID="cbNotifyStandard" Text="" Style="vertical-align: middle" AutoPostBack="true" OnCheckedChanged="cbNotifyStandard_CheckedChanged" />
                                                                    <asp:Label runat="server" ID="lblNotifyStandard" Text="Notify Standard" Font-Size="12px"></asp:Label>
                                                                </td>
                                                                <td style="width: 28%; text-align: left">
                                                                    <asp:Label runat="server" ID="lblNotifyStandardValue" Text="" Font-Size="12px" ForeColor="#bb4342" Font-Italic="true"></asp:Label>
                                                                </td>
                                                                <td style="width: 17%; text-align: left">
                                                                    <asp:CheckBox runat="server" ID="cbNotifyAssignee" Text="" Style="vertical-align: middle" AutoPostBack="true" OnCheckedChanged="cbNotifyAssignee_CheckedChanged" />
                                                                    <asp:Label runat="server" ID="lblNotifyAssignee" Text="Notify Assignee" Font-Size="12px"></asp:Label>
                                                                </td>
                                                                <td style="width: 18%; text-align: left">
                                                                    <asp:Label runat="server" ID="lblNotifyAssigneeValue" Text="" Font-Size="12px" ForeColor="#bb4342" Font-Italic="true"></asp:Label>
                                                                </td>
                                                                <td rowspan="2" style="width: 5%; text-align: right">
                                                                    <asp:CheckBox runat="server" ID="cbSendComments" />
                                                                </td>
                                                                <td rowspan="2" style="width: 15%; text-align: center; font-size: 12px">Include All Comments in Notification
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 17%; text-align: left; vertical-align: middle">
                                                                    <asp:CheckBox runat="server" ID="cbNotifyOther" Text="" Style="vertical-align: middle" AutoPostBack="true" OnCheckedChanged="cbNotifyOther_CheckedChanged" />
                                                                    <asp:Label runat="server" ID="lblNotifyOther" Text="Notify Other" Font-Size="12px"></asp:Label>
                                                                </td>
                                                                <td style="width: 28%; text-align: left; vertical-align: middle">
                                                                    <telerik:RadComboBox runat="server" ID="ddlNotifyOther" DataTextField="Address" DataValueField="Name" Height="250px" Width="150px" AutoPostBack="true"
                                                                        CheckBoxes="true" DropDownWidth="300px" ItemType="Tingle_WebForms.Models.NotifyOtherList" Skin="Default" SelectMethod="GetOtherEmails"
                                                                        EnableCheckAllItemsCheckBox="true" EmptyMessage="Type to Filter" AllowCustomText="true" Filter="Contains" MarkFirstMatch="true"
                                                                        OnClientItemChecked="ClearBox" OnClientBlur="ComboBoxBlur" OnClientFocus="ComboBoxFocus" Localization-CheckAllString="Select all Emails"
                                                                        OnSelectedIndexChanged="ddlNotifyOther_SelectedIndexChanged" CausesValidation="false" OnItemChecked="ddlNotifyOther_ItemChecked" OnCheckAllCheck="ddlNotifyOther_CheckAllCheck">
                                                                        <ItemTemplate>
                                                                            <%# Eval("Name") %> -- <%# Eval("Address") %>
                                                                        </ItemTemplate>
                                                                    </telerik:RadComboBox>
                                                                    <telerik:RadButton ID="btnAddNewEmail" runat="server" Text="Add New Notification Email" ButtonType="SkinnedButton"
                                                                        CssClass="plusSignImageBtn" CausesValidation="false" AutoPostBack="false" OnClientClicked="ShowAddNewEmailTd" ToolTip="Add New Notification Email">
                                                                        <Image EnableImageButton="true" />
                                                                    </telerik:RadButton>
                                                                </td>
                                                                <td style="width: 17%; text-align: left">
                                                                    <asp:CheckBox runat="server" ID="cbNotifyRequester" Text="" Style="vertical-align: middle" AutoPostBack="true" OnCheckedChanged="cbNotifyRequester_CheckedChanged" />
                                                                    <asp:Label runat="server" ID="lblNotifyRequester" Text="Notify Requester" Font-Size="12px"></asp:Label>
                                                                </td>
                                                                <td style="width: 18%; text-align: left">
                                                                    <asp:Label runat="server" ID="lblNotifyRequesterValue" Text="" Font-Size="12px" ForeColor="#bb4342" Font-Italic="true"></asp:Label>
                                                                </td>

                                                            </tr>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 100%;" colspan="4">
                                                    <div style="width: 80%; border: 0; margin: 0 auto; display: none; text-align: center" id="divAddNewEmail">
                                                        <table style="border: 1px solid #000; border-radius: 5px;">
                                                            <tr>
                                                                <td>Name:</td>
                                                                <td>
                                                                    <telerik:RadTextBox ID="txtNameInsert" runat="server" Text="" EmptyMessage="Enter Name Here" Width="150px"></telerik:RadTextBox>
                                                                    <asp:RequiredFieldValidator ID="rfvTxtNameInsert" runat="server" ErrorMessage="*" Text="*" ForeColor="Red" ValidationGroup="NotificationEmailInsert"
                                                                        ControlToValidate="txtNameInsert"></asp:RequiredFieldValidator>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>Address:</td>
                                                                <td>
                                                                    <telerik:RadTextBox ID="txtAddressInsert" runat="server" Text="" EmptyMessage="Enter Email Address Here" Width="150px"></telerik:RadTextBox>
                                                                    <asp:RequiredFieldValidator ID="rfvTxtAddressInsert" runat="server" ErrorMessage="*" Text="*" ForeColor="Red" ValidationGroup="NotificationEmailInsert"
                                                                        ControlToValidate="txtAddressInsert"></asp:RequiredFieldValidator>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>Status:</td>
                                                                <td>
                                                                    <asp:RadioButtonList ID="rblNotificationEmailStatusInsert" runat="server" RepeatDirection="Horizontal" BorderStyle="None">
                                                                        <asp:ListItem Value="1" Selected="True">Enabled</asp:ListItem>
                                                                        <asp:ListItem Value="0">Disabled</asp:ListItem>
                                                                    </asp:RadioButtonList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <telerik:RadButton ID="btnInsertEmail" runat="server" Text="Add Email" OnClick="btnInsertEmail_Click" ValidationGroup="NotificationEmailInsert" />
                                                                    <telerik:RadButton runat="server" ID="btnCancelNewEmail" Text="Cancel" OnClientClicked="CancelNewEmail" AutoPostBack="false" CausesValidation="false"></telerik:RadButton>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <asp:Label runat="server" Text="" ID="lblInsertEmailMessage" ForeColor="Red"></asp:Label>
                                                                </td>
                                                            </tr>
                                                        </table>

                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="4">
                                                    <br />
                                                    <br />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class="tdcenter">
                                                    <asp:Button ID="btnUpdate" runat="server" CausesValidation="True" CommandName="Update" Text="Update Request" CssClass="normalButton" />&nbsp;&nbsp;&nbsp;
                                                    <asp:Button ID="btnCancel" runat="server" CausesValidation="false" CommandName="Cancel" Text="Back" CssClass="normalButton" OnClick="btnCancel_Click" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class="tdcenter">
                                                    <div style="width: 14%; float: left">
                                                        <br />
                                                    </div>
                                                    <div style="width: 70%; float: left">
                                                        <p class="smallText" style="font-weight: bold;">
                                                            Request Notifications Sent To:<br />
                                                            <br />
                                                            <asp:Label ID="lblEmailsSentTo" Style="color: black; font-style: italic; font-size: 12px; font-weight: normal;" runat="server"></asp:Label>
                                                        </p>
                                                    </div>
                                                    <div style="width: 15%; float: right">
                                                        <span style="font-weight: bold; color: #bc4445; font-size: 12px">Created By:</span><br />
                                                        <asp:Label runat="server" ID="lblCreatedBy" Style="font-size: 12px; color: black; font-weight: normal" Text='<%# Eval("SubmittedUser.DisplayName") %>'></asp:Label><br />
                                                        <br />
                                                        <span style="font-weight: bold; color: #bc4445; font-size: 12px">Last Updated By:</span><br />
                                                        <asp:Label runat="server" ID="lblLastUpdatedBy" Style="font-size: 12px; color: black; font-weight: normal" Text='<%# Eval("LastModifiedUser.DisplayName") %>'></asp:Label><br />
                                                        <br />
                                                        <span style="font-weight: bold; color: #bc4445; font-size: 12px">Last Update:</span><br />
                                                        <asp:Label runat="server" ID="lblLastUpdated" Style="font-size: 12px; color: black; font-weight: normal" Text='<%# ((DateTime)Eval("LastModifiedTimestamp")).ToShortDateString() %>'></asp:Label>
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>

                                        <div style="width: 100%; padding-top: 10px">
                                            <telerik:RadTextBox runat="server" ID="txtNewComment" TextMode="MultiLine" Width="81%" Style="text-align: left; margin: 0 auto; padding: 3px; border: 1px solid black"
                                                ValidationGroup="NewComment" MaxLength="300" Height="60px">
                                            </telerik:RadTextBox>
                                            <asp:RequiredFieldValidator ID="rfvTxtNewComment" runat="server" ErrorMessage="*" Text="*" ForeColor="Red" ValidationGroup="NewComment"
                                                ControlToValidate="txtNewComment"></asp:RequiredFieldValidator>
                                            <br />
                                        </div>
                                        <div style="width: 81%; color: #bc4445; margin: 0 auto; text-align: left; padding-bottom: 15px; height: 25px">
                                            <div style="float: left; width: 45%">
                                                <span style="font-size: 10px">300 Characters Max</span>
                                            </div>
                                            <div style="float: right; text-align: right; width: 45%; padding-right: 5px; padding-top: 5px;">
                                                <asp:Button ID="btnAddComment" runat="server" CausesValidation="True" Text="Post Comment" CssClass="normalButton"
                                                    OnClick="btnAddComment_Click" ValidationGroup="NewComment" />
                                            </div>
                                        </div>
                                        <div style="width: 100%; padding-top: 10px">
                                            <div style="width: 80%; max-width: 800px; background-color: #FFF; margin: 0 auto; text-align: left; font-size: 12px; color: #bc4445; overflow: hidden; word-wrap: break-word;">
                                                <asp:CheckBox runat="server" ID="cbShowSystemComments" Text="Show System Comments" AutoPostBack="true" 
                                                    OnCheckedChanged="cbShowSystemComments_CheckedChanged" />
                                            </div>
                                            <asp:Repeater runat="server" ID="rptrComments" SelectMethod="rptrComments_GetData" ItemType="Tingle_WebForms.Models.Comments">
                                                <ItemTemplate>
                                                    <asp:Literal runat="server" ID="ltlComment" Text='<%# LoadCommentLiteral(Convert.ToBoolean(Eval("SystemComment")), Eval("Note").ToString(), Convert.ToString(Eval("User.DisplayName")), Eval("Timestamp").ToString()) %>'></asp:Literal>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </div>
                                    </asp:PlaceHolder>
                                </EditItemTemplate>
                            </asp:FormView>
                            </asp:Panel>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <div id="loadingDiv">
                        <div id="loadingGif">
                            <img src="Images/loading.gif" />
                        </div>
                    </div>
</asp:Content>
