using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace WebFormsAssessment
{
    public partial class Employees : System.Web.UI.Page
    {
        readonly string connStr = ConfigurationManager.ConnectionStrings["DataBase"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCountries();
            }
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditRow")
            {
                //Because we do not have id or somthing
                //I have choosen mobileNumber to get the data
                string mobileNumber = e.CommandArgument.ToString();

                SqlConnection con = new SqlConnection(connStr);
                string query = "Select * from Employees where MobileNumber = @MobileNumber";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@MobileNumber", mobileNumber);
                con.Open();

                SqlDataReader dr =  cmd.ExecuteReader();

                if (dr.HasRows)
                {
                    if (dr.Read())
                    {
                        txtName.Text = dr["Name"].ToString();
                        txtDob.Text = Convert.ToDateTime(dr["DateOfBirth"]).ToString("yyyy-MM-dd");
                        txtMobile.Text = dr["MobileNumber"].ToString();
                        txtAadhaar.Text = dr["AadhaarNumber"].ToString();
                        txtPAN.Text = dr["PANNumber"].ToString();
                        ddlCountry.SelectedValue = dr["Country"].ToString();

                        LoadStates(dr["Country"].ToString());
                        ddlState.SelectedValue = dr["State"].ToString();

                        LoadCities(dr["State"].ToString());
                        ddlCity.SelectedValue = dr["City"].ToString();

                        ddlGender.SelectedValue = dr["Gender"].ToString();
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "$('#editModal').modal('show');", true);
                    }

                    dr.Close();
                }
                con.Close();
            }
            if (e.CommandName == "DeleteRow")
            {
                string mobile = e.CommandArgument.ToString();
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("DELETE FROM Employees WHERE MobileNumber = @Mobile", conn);
                    cmd.Parameters.AddWithValue("@Mobile", mobile);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }

                GridView1.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Alert", "alert('Employee deleted successfully.');", true);
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "$('#editModal').modal('show');", true);
                return;
            }
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SaveOrUpdateEmployee", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@MobileNumber", txtMobile.Text);
                cmd.Parameters.AddWithValue("@Name", txtName.Text);
                cmd.Parameters.AddWithValue("@DateOfBirth", txtDob.Text);
                cmd.Parameters.AddWithValue("@AadhaarNumber", txtAadhaar.Text);
                cmd.Parameters.AddWithValue("@PANNumber", txtPAN.Text);
                cmd.Parameters.AddWithValue("@Country", ddlCountry.SelectedValue);
                cmd.Parameters.AddWithValue("@State", ddlState.SelectedValue);
                cmd.Parameters.AddWithValue("@City", ddlCity.SelectedValue);
                cmd.Parameters.AddWithValue("@Gender", ddlGender.SelectedValue);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();

                    GridView1.DataBind();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "$('#editModal').modal('hide'); alert('Employee saved successfully.');", true);
                }
                catch (SqlException ex)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", $"alert('{ex.Message}');", true);
                }
            }
        }

        #region DropDownBindings
        private void BindCountries()
        {
            ddlCountry.Items.Clear();
            ddlCountry.Items.Add("Select");
            ddlCountry.Items.Add("India");
            ddlCountry.Items.Add("USA");
        }

        protected void ddlCountry_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadStates(ddlCountry.SelectedValue);
        }

        protected void ddlState_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadCities(ddlState.SelectedValue);
        }

        private void LoadStates(string country)
        {
            ddlState.Items.Clear();
            ddlCity.Items.Clear();

            if (country == "India")
            {
                ddlState.Items.Add("Uttar Pradesh");
                ddlState.Items.Add("Maharashtra");
                ddlState.Items.Add("Delhi");
            }
            else if (country == "USA")
            {
                ddlState.Items.Add("California");
                ddlState.Items.Add("Texas");
            }

            ddlState.Items.Insert(0, new ListItem("Select", ""));
            ddlCity.Items.Insert(0, new ListItem("Select", ""));
        }
        private void LoadCities(string state)
        {
            ddlCity.Items.Clear();

            if (state == "Uttar Pradesh")
            {
                ddlCity.Items.Add("Lucknow");
                ddlCity.Items.Add("Kanpur");
            }
            else if (state == "Maharashtra")
            {
                ddlCity.Items.Add("Mumbai");
                ddlCity.Items.Add("Pune");
            }
            else if (state == "Delhi")
            {
                ddlCity.Items.Add("New Delhi");
                ddlCity.Items.Add("East Delhi");
            }
            else if (state == "California")
            {
                ddlCity.Items.Add("San Francisco");
                ddlCity.Items.Add("Los Angeles");
            }
            else if (state == "Texas")
            {
                ddlCity.Items.Add("Austin");
                ddlCity.Items.Add("Dallas");
            }

            ddlCity.Items.Insert(0, new ListItem("Select", ""));
        }
        #endregion
    }
}