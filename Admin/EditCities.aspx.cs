using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace EventGlint.Admin
{
    public partial class EditCities : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null) { Response.Redirect("~/Log.aspx"); return; }
            lbl_AvatarInitial.Text = (Session["Username"]?.ToString() ?? "A")[0].ToString().ToUpper();
            if (!IsPostBack) LoadGrid();
        }

        private void LoadGrid()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter("SELECT CityId,Name,State,Country,CreatedAt FROM Cities ORDER BY Name", con);
                    DataTable dt = new DataTable(); da.Fill(dt);
                    gvCities.DataSource = dt; gvCities.DataBind();
                    lblCount.Text = dt.Rows.Count + " record(s)";
                }
            }
            catch (Exception ex) { ShowMessage("❌ " + ex.Message, false); }
        }

        protected void btnInsert_Click(object sender, EventArgs e)
        {
            if (!Validate()) return;
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("INSERT INTO Cities(Name,State,Country,CreatedAt) VALUES(@n,@s,@c,GETDATE())", con);
                    cmd.Parameters.AddWithValue("@n", txtCityName.Text.Trim());
                    cmd.Parameters.AddWithValue("@s", txtState.Text.Trim());
                    cmd.Parameters.AddWithValue("@c", txtCountry.Text.Trim());
                    con.Open(); cmd.ExecuteNonQuery();
                }
                ShowMessage("✅ City inserted!", true); ClearFields(); LoadGrid();
            }
            catch (Exception ex) { ShowMessage("❌ " + ex.Message, false); }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtCityId.Text)) { ShowMessage("⚠️ Select a record first.", false); return; }
            if (!Validate()) return;
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("UPDATE Cities SET Name=@n,State=@s,Country=@c WHERE CityId=@id", con);
                    cmd.Parameters.AddWithValue("@n", txtCityName.Text.Trim());
                    cmd.Parameters.AddWithValue("@s", txtState.Text.Trim());
                    cmd.Parameters.AddWithValue("@c", txtCountry.Text.Trim());
                    cmd.Parameters.AddWithValue("@id", int.Parse(txtCityId.Text));
                    con.Open(); cmd.ExecuteNonQuery();
                }
                ShowMessage("✅ City updated!", true); ClearFields(); LoadGrid();
            }
            catch (Exception ex) { ShowMessage("❌ " + ex.Message, false); }
        }

        protected void btnClear_Click(object sender, EventArgs e) { ClearFields(); lblMessage.Visible = false; }

        protected void gvCities_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "SelectRow")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Cities WHERE CityId=@id", con);
                    da.SelectCommand.Parameters.AddWithValue("@id", id);
                    DataTable dt = new DataTable(); da.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        txtCityId.Text = dt.Rows[0]["CityId"].ToString();
                        txtCityName.Text = dt.Rows[0]["Name"].ToString();
                        txtState.Text = dt.Rows[0]["State"].ToString();
                        txtCountry.Text = dt.Rows[0]["Country"].ToString();
                        lblMessage.Visible = false;
                    }
                }
            }
            else if (e.CommandName == "DeleteRow")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("DELETE FROM Cities WHERE CityId=@id", con);
                    cmd.Parameters.AddWithValue("@id", id);
                    con.Open(); cmd.ExecuteNonQuery();
                }
                ShowMessage("🗑️ City deleted!", true); ClearFields(); LoadGrid();
            }
        }

        private void ClearFields() { txtCityId.Text = txtCityName.Text = txtState.Text = txtCountry.Text = ""; }
        private bool Validate()
        {
            if (string.IsNullOrEmpty(txtCityName.Text.Trim())) { ShowMessage("⚠️ City Name required.", false); return false; }
            if (string.IsNullOrEmpty(txtState.Text.Trim())) { ShowMessage("⚠️ State required.", false); return false; }
            if (string.IsNullOrEmpty(txtCountry.Text.Trim())) { ShowMessage("⚠️ Country required.", false); return false; }
            return true;
        }
        private void ShowMessage(string msg, bool ok) { lblMessage.Text = msg; lblMessage.CssClass = ok ? "alert msg-success" : "alert msg-error"; lblMessage.Visible = true; }
    }
}