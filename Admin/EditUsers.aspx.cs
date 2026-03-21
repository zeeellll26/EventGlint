using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace EventGlint.Admin
{
    public partial class EditUsers : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null) { Response.Redirect("~/Log.aspx"); return; }
            lbl_AvatarInitial.Text = (Session["Username"]?.ToString() ?? "A")[0].ToString().ToUpper();
            if (!IsPostBack) { BindCities(); LoadGrid(); }
        }

        private void BindCities()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter("SELECT CityId, Name + ', ' + State AS Label FROM Cities ORDER BY Name", con);
                    DataTable dt = new DataTable(); da.Fill(dt);
                    ddlCityId.DataSource = dt; ddlCityId.DataValueField = "CityId"; ddlCityId.DataTextField = "Label"; ddlCityId.DataBind();
                    ddlCityId.Items.Insert(0, new ListItem("-- Select City --", ""));
                }
            }
            catch { ddlCityId.Items.Insert(0, new ListItem("-- Error --", "")); }
        }

        private void LoadGrid()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter(@"
                        SELECT u.UserId, u.Username, u.Email, u.Phone,
                               ISNULL(c.Name, '—') AS CityName, u.CreatedAt
                        FROM Users u LEFT JOIN Cities c ON c.CityId = u.CityId
                        ORDER BY u.UserId DESC", con);
                    DataTable dt = new DataTable(); da.Fill(dt);
                    gvData.DataSource = dt; gvData.DataBind();
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
                    SqlCommand cmd = new SqlCommand(@"
                        INSERT INTO Users(Username,Email,Phone,Password,ProfilePic,DateOfBirth,CityId,CreatedAt)
                        VALUES(@u,@em,@ph,@pw,@pp,@dob,@cid,GETDATE())", con);
                    SetParams(cmd); con.Open(); cmd.ExecuteNonQuery();
                }
                ShowMessage("✅ User inserted!", true); ClearFields(); LoadGrid();
            }
            catch (Exception ex) { ShowMessage("❌ " + ex.Message, false); }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtUserId.Text)) { ShowMessage("⚠️ Select a record first.", false); return; }
            if (!Validate()) return;
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(@"
                        UPDATE Users SET Username=@u,Email=@em,Phone=@ph,Password=@pw,
                        ProfilePic=@pp,DateOfBirth=@dob,CityId=@cid,UpdatedAt=GETDATE()
                        WHERE UserId=@id", con);
                    SetParams(cmd); cmd.Parameters.AddWithValue("@id", int.Parse(txtUserId.Text));
                    con.Open(); cmd.ExecuteNonQuery();
                }
                ShowMessage("✅ User updated!", true); ClearFields(); LoadGrid();
            }
            catch (Exception ex) { ShowMessage("❌ " + ex.Message, false); }
        }

        private void SetParams(SqlCommand cmd)
        {
            cmd.Parameters.AddWithValue("@u", txtUsername.Text.Trim());
            cmd.Parameters.AddWithValue("@em", txtEmail.Text.Trim());
            cmd.Parameters.AddWithValue("@ph", txtPhone.Text.Trim());
            cmd.Parameters.AddWithValue("@pw", txtPassword.Text.Trim());
            cmd.Parameters.AddWithValue("@pp", txtProfilePic.Text.Trim());
            cmd.Parameters.AddWithValue("@dob", string.IsNullOrEmpty(txtDOB.Text) ? (object)DBNull.Value : DateTime.Parse(txtDOB.Text));
            cmd.Parameters.AddWithValue("@cid", string.IsNullOrEmpty(ddlCityId.SelectedValue) ? (object)DBNull.Value : int.Parse(ddlCityId.SelectedValue));
        }

        protected void btnClear_Click(object sender, EventArgs e) { ClearFields(); lblMessage.Visible = false; }

        protected void gvData_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "SelectRow")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Users WHERE UserId=@id", con);
                    da.SelectCommand.Parameters.AddWithValue("@id", id);
                    DataTable dt = new DataTable(); da.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        DataRow r = dt.Rows[0];
                        txtUserId.Text = r["UserId"].ToString();
                        txtUsername.Text = r["Username"].ToString();
                        txtEmail.Text = r["Email"].ToString();
                        txtPhone.Text = r["Phone"]?.ToString();
                        txtPassword.Text = r["Password"].ToString();
                        txtProfilePic.Text = r["ProfilePic"]?.ToString();
                        if (r["DateOfBirth"] != DBNull.Value) txtDOB.Text = Convert.ToDateTime(r["DateOfBirth"]).ToString("yyyy-MM-dd");
                        if (r["CityId"] != DBNull.Value) ddlCityId.SelectedValue = r["CityId"].ToString();
                        lblMessage.Visible = false;
                    }
                }
            }
            else if (e.CommandName == "DeleteRow")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                { SqlCommand cmd = new SqlCommand("DELETE FROM Users WHERE UserId=@id", con); cmd.Parameters.AddWithValue("@id", id); con.Open(); cmd.ExecuteNonQuery(); }
                ShowMessage("🗑️ User deleted!", true); ClearFields(); LoadGrid();
            }
        }

        private void ClearFields() { txtUserId.Text = txtUsername.Text = txtEmail.Text = txtPhone.Text = txtPassword.Text = txtProfilePic.Text = txtDOB.Text = ""; ddlCityId.SelectedIndex = 0; }
        private bool Validate()
        {
            if (string.IsNullOrEmpty(txtUsername.Text.Trim())) { ShowMessage("⚠️ Username required.", false); return false; }
            if (string.IsNullOrEmpty(txtEmail.Text.Trim())) { ShowMessage("⚠️ Email required.", false); return false; }
            if (string.IsNullOrEmpty(txtPassword.Text.Trim())) { ShowMessage("⚠️ Password required.", false); return false; }
            return true;
        }
        private void ShowMessage(string msg, bool ok) { lblMessage.Text = msg; lblMessage.CssClass = ok ? "alert msg-success" : "alert msg-error"; lblMessage.Visible = true; }
    }
}