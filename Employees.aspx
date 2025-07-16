<%@ Page Title="Employees" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Employees.aspx.cs" Inherits="WebFormsAssessment.Employees" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main aria-labelledby="title">
        <div class="container mt-4">

            <!-- Add Employee Button -->
            <div class="text-right mb-3">
                <asp:Button ID="btnAddNew" runat="server" Text="Add Employee" CssClass="btn btn-success"
                    OnClientClick="clearForm(); $('#editModal').modal('show'); return false;" />
            </div>

            <!-- GridView Panel -->
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <asp:GridView ID="GridView1" runat="server" OnRowCommand="GridView1_RowCommand" AutoGenerateColumns="False"
                        CssClass="table table-bordered table-striped table-hover" DataKeyNames="MobileNumber" DataSourceID="SqlDataSource1">
                        <Columns>
                            <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                            <asp:BoundField DataField="DateOfBirth" HeaderText="Date of Birth" SortExpression="DateOfBirth" />
                            <asp:BoundField DataField="MobileNumber" HeaderText="Mobile Number" ReadOnly="True" SortExpression="MobileNumber" />
                            <asp:BoundField DataField="AadhaarNumber" HeaderText="Aadhaar Number" SortExpression="AadhaarNumber" />
                            <asp:BoundField DataField="PANNumber" HeaderText="PAN Number" SortExpression="PANNumber" />
                            <asp:BoundField DataField="Country" HeaderText="Country" SortExpression="Country" />
                            <asp:BoundField DataField="State" HeaderText="State" SortExpression="State" />
                            <asp:BoundField DataField="City" HeaderText="City" SortExpression="City" />
                            <asp:BoundField DataField="Gender" HeaderText="Gender" SortExpression="Gender" />
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditRow" CommandArgument='<%# Eval("MobileNumber") %>'
                                        CssClass="btn btn-sm btn-info" CausesValidation="false">Edit</asp:LinkButton>
                                    &nbsp;
                                    <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteRow" CommandArgument='<%# Eval("MobileNumber") %>'
                                        CssClass="btn btn-sm btn-danger" CausesValidation="false"
                                        OnClientClick="return confirm('Are you sure you want to delete this record?');">Delete</asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="alert alert-warning text-center m-0">
                                No employee records found.
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </ContentTemplate>
            </asp:UpdatePanel>

            <!-- Modal Form -->
            <div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="editModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg" role="document">
                    <asp:UpdatePanel ID="UpdatePanelModal" runat="server">
                        <ContentTemplate>
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="editModalLabel">Employee Details</h5>
                                </div>
                                <div class="modal-body">
                                    <div class="row">
                                        <div class="col-md-6 form-group">
                                            <label>Name</label>
                                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control" />
                                            <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName"
                                                ErrorMessage="Name is required" CssClass="text-danger" Display="Dynamic" />
                                        </div>
                                        <div class="col-md-6 form-group">
                                            <label>Date of Birth</label>
                                            <asp:TextBox ID="txtDob" runat="server" CssClass="form-control" TextMode="Date" />
                                            <asp:RequiredFieldValidator ID="rfvDob" runat="server" ControlToValidate="txtDob"
                                                ErrorMessage="Date of Birth is required" CssClass="text-danger" Display="Dynamic" />
                                        </div>
                                        <div class="col-md-6 form-group">
                                            <label>Mobile Number</label>
                                            <asp:TextBox ID="txtMobile" runat="server" CssClass="form-control" MaxLength="10" />
                                            <asp:RequiredFieldValidator ID="rfvMobile" runat="server" ControlToValidate="txtMobile"
                                                ErrorMessage="Mobile number is required" CssClass="text-danger"  Display="Dynamic" />
                                            <asp:RegularExpressionValidator ID="revMobile" runat="server" ControlToValidate="txtMobile"
                                                ErrorMessage="Enter valid 10-digit mobile number" CssClass="text-danger"
                                                ValidationExpression="^\d{10}$" Display="Dynamic" />
                                        </div>
                                        <div class="col-md-6 form-group">
                                            <label>Aadhaar Number</label>
                                            <asp:TextBox ID="txtAadhaar" runat="server" CssClass="form-control" MaxLength="12"/>
                                            <asp:RequiredFieldValidator ID="rfvAadhaar" runat="server" ControlToValidate="txtAadhaar"
                                                ErrorMessage="Aadhaar is required" CssClass="text-danger" Display="Dynamic" />
                                            <asp:RegularExpressionValidator ID="revAadhaar" runat="server" ControlToValidate="txtAadhaar"
                                                ErrorMessage="Enter valid 12-digit Aadhaar number" CssClass="text-danger"
                                                ValidationExpression="^\d{12}$" Display="Dynamic" />
                                        </div>
                                        <div class="col-md-6 form-group">
                                            <label>Country</label>
                                            <asp:DropDownList ID="ddlCountry" runat="server" CssClass="form-control" AutoPostBack="true"
                                                OnSelectedIndexChanged="ddlCountry_SelectedIndexChanged" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="ddlCountry"
                                                ErrorMessage="Please select a country" InitialValue="" CssClass="text-danger" Display="Dynamic" />
                                        </div>
                                        <div class="col-md-6 form-group">
                                            <label>PAN Number</label>
                                            <asp:TextBox ID="txtPAN" runat="server" CssClass="form-control" MaxLength="15"/>
                                            <asp:RequiredFieldValidator ID="rfvPAN" runat="server" ControlToValidate="txtPAN"
                                                ErrorMessage="PAN Number is required" CssClass="text-danger" Display="Dynamic" />
                                            <asp:RegularExpressionValidator ID="revPAN" runat="server" ControlToValidate="txtPAN"
                                                ValidationExpression="^[A-Z]{5}[0-9]{4}[A-Z]{1}$"
                                                ErrorMessage="Invalid PAN format (e.g., ABCDE1234F)" CssClass="text-danger" Display="Dynamic" />
                                        </div>
                                        <div class="col-md-6 form-group">
                                            <label>State</label>
                                            <asp:DropDownList ID="ddlState" runat="server" CssClass="form-control" AutoPostBack="true"
                                                OnSelectedIndexChanged="ddlState_SelectedIndexChanged" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="ddlState"
                                                ErrorMessage="Please select a state" InitialValue="" CssClass="text-danger" Display="Dynamic" />
                                        </div>
                                        <div class="col-md-6 form-group">
                                            <label>Gender</label>
                                            <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-control">
                                                <asp:ListItem Text="Select" Value="" />
                                                <asp:ListItem Text="Male" Value="Male" />
                                                <asp:ListItem Text="Female" Value="Female" />
                                                <asp:ListItem Text="Other" Value="Other" />
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="rfvGender" runat="server" ControlToValidate="ddlGender"
                                                ErrorMessage="Please select gender"  CssClass="text-danger" Display="Dynamic" />
                                        </div>
                                        <div class="col-md-6 form-group">
                                            <label>City</label>
                                            <asp:DropDownList ID="ddlCity" runat="server" CssClass="form-control" />
                                             <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="ddlCity"
                                                ErrorMessage="Please select a city" InitialValue="" CssClass="text-danger" Display="Dynamic" />
                                        </div>
                                    </div>
                                </div>

                                <div class="modal-footer">
                                    <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-primary" OnClick="btnSave_Click" />
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>

            <!-- SQL Data Source -->
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:Database %>" 
                SelectCommand="SELECT * FROM [Employees]"></asp:SqlDataSource>
        </div>
    </main>
    <script type="text/javascript">
        function clearForm() {
            document.getElementById('<%= txtName.ClientID %>').value = '';
            document.getElementById('<%= txtDob.ClientID %>').value = '';
            document.getElementById('<%= txtMobile.ClientID %>').value = '';
            document.getElementById('<%= txtAadhaar.ClientID %>').value = '';
            document.getElementById('<%= txtPAN.ClientID %>').value = '';
            document.getElementById('<%= ddlCountry.ClientID %>').selectedIndex = 0;
            document.getElementById('<%= ddlState.ClientID %>').selectedIndex = 0;
            document.getElementById('<%= ddlCity.ClientID %>').selectedIndex = 0;
            document.getElementById('<%= ddlGender.ClientID %>').selectedIndex = 0;
        }
    </script>
</asp:Content>
