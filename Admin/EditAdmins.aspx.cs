using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EventGlint.Admin
{
    public partial class EditAdmins : System.Web.UI.Page
    {
        //String connStr = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;
        //protected void Page_Load(object sender, EventArgs e)
        //{
        //    if (!IsPostBack)
        //    {
        //        Bind_Grid();
        //    }
        //}

        //protected void Bind_Grid()
        //{
        //    SqlConnection con = new SqlConnection(strcon);

        //    string qry = "SELECT * FROM Admins";

        //    con.Open();
        //    SqlDataAdapter adpt = new SqlDataAdapter(qry, con);
        //    DataSet ds = new DataSet();
        //    adpt.Fill(ds);

        //    gv_Admins.DataSource = ds;
        //    gv_Admins.DataBind();
        //    con.Close();
        //}

        //protected void gv_Admins_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    GridViewRow row = gv_Admins.SelectedRow;
        //    txt_AdminID.Text = row.Cells[1].Text;
        //    txt_Username.Text = row.Cells[2].Text;
        //    txt_Email.Text = row.Cells[3].Text;
        //    txt_Password.Text = row.Cells[4].Text;
        //    txt_Role.Text = row.Cells[5].Text;
        //    txt_CreatedAt.Text = row.Cells[6].Text;
        //}

        //protected void gv_Admins_RowDeleting(object sender, GridViewDeleteEventArgs e)
        //{
        //    GridViewRow row = gv_Admins.Rows[e.RowIndex];
        //    int adminID = Convert.ToInt32(row.Cells[1].Text);

        //    string qry = "DELETE FROM Admins WHERE AdminId = @AdminId";

        //    SqlConnection con = new SqlConnection(strcon);
        //    SqlCommand cmd = new SqlCommand(qry, con);

        //    cmd.Parameters.AddWithValue("@AdminId", adminID);
        //    con.Open();
        //    cmd.ExecuteNonQuery();
        //    con.Close();
        //    Bind_Grid();
        //}

        //protected void btn_Save_Click(object sender, EventArgs e)
        //{
        //    SqlConnection con = new SqlConnection(strcon);

        //    string qry = "UPDATE Admins SET Username = @Username, Email = @Email, Password = @Password, Role = @Role WHERE AdminId = @AdminId";

        //    SqlCommand cmd = new SqlCommand(qry, con);
        //    cmd.Parameters.AddWithValue("@AdminId", txt_AdminID.Text);
        //    cmd.Parameters.AddWithValue("@Username", txt_Username.Text);
        //    cmd.Parameters.AddWithValue("@Email", txt_Email.Text);
        //    cmd.Parameters.AddWithValue("@Password", txt_Password.Text);
        //    cmd.Parameters.AddWithValue("@Role", txt_Role.Text);
        //    con.Open();
        //    cmd.ExecuteNonQuery();
        //    Response.Write("Admin Details Updated..");
        //    con.Close();
        //}

        //protected void btn_Insert_Click(object sender, EventArgs e)
        //{
        //    SqlConnection con = new SqlConnection(strcon);

        //    string qry = "INSERT INTO Admins(Username,Email,Password,Role) VALUES(@Username,@Email,@Password,@Role);";

        //    SqlCommand cmd = new SqlCommand(qry, con);
        //    //cmd.Parameters.AddWithValue("@AdminId", txt_AdminID.Text);
        //    cmd.Parameters.AddWithValue("@Username", txt_Username.Text);
        //    cmd.Parameters.AddWithValue("@Email", txt_Email.Text);
        //    cmd.Parameters.AddWithValue("@Password", txt_Password.Text);
        //    cmd.Parameters.AddWithValue("@Role", txt_Role.Text);
        //    con.Open();
        //    cmd.ExecuteNonQuery();
        //    Response.Write("<script>alert('Record Inserted..');</script>");
        //    con.Close();
        //}

        private string connStr = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;

        // =====================================================================
        //  Page Load
        // =====================================================================
        protected void Page_Load(object sender, EventArgs e)
        {
            // Same session guard as AdminPanel
            if (Session["Username"] == null)
            {
                Response.Redirect("~/Log.aspx");
                return;
            }

            // Avatar initial from session
            string name = Session["Username"]?.ToString() ?? "A";
            lbl_AvatarInitial.Text = name.Length > 0 ? name[0].ToString().ToUpper() : "A";

            if (!IsPostBack)
                LoadGrid();
        }

        // =====================================================================
        //  Load all admins into GridView
        // =====================================================================
        private void LoadGrid()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        "SELECT AdminId, Username, Email, Password, Role, CreatedAt FROM Admins ORDER BY AdminId", con);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvAdmins.DataSource = dt;
                    gvAdmins.DataBind();
                    lblCount.Text = dt.Rows.Count + " record(s)";
                }
            }
            catch (Exception ex)
            {
                ShowMessage("❌ Error loading data: " + ex.Message, false);
            }
        }

        // =====================================================================
        //  INSERT — Add new admin
        // =====================================================================
        protected void btnInsert_Click(object sender, EventArgs e)
        {
            if (!ValidateFields()) return;

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        "INSERT INTO Admins (Username, Email, Password, Role, CreatedAt) VALUES (@u, @em, @p, @r, GETDATE())", con);
                    cmd.Parameters.AddWithValue("@u", txtUsername.Text.Trim());
                    cmd.Parameters.AddWithValue("@em", txtEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@p", txtPassword.Text.Trim());
                    cmd.Parameters.AddWithValue("@r", ddlRole.SelectedValue);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                ShowMessage("✅ Admin inserted successfully!", true);
                ClearFields();
                LoadGrid();
            }
            catch (Exception ex)
            {
                ShowMessage("❌ Error: " + ex.Message, false);
            }
        }

        // =====================================================================
        //  SAVE — Update existing admin
        // =====================================================================
        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtAdminId.Text))
            {
                ShowMessage("⚠️ Please select a record first using the Edit button.", false);
                return;
            }
            if (!ValidateFields()) return;

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        "UPDATE Admins SET Username=@u, Email=@em, Password=@p, Role=@r WHERE AdminId=@id", con);
                    cmd.Parameters.AddWithValue("@u", txtUsername.Text.Trim());
                    cmd.Parameters.AddWithValue("@em", txtEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@p", txtPassword.Text.Trim());
                    cmd.Parameters.AddWithValue("@r", ddlRole.SelectedValue);
                    cmd.Parameters.AddWithValue("@id", txtAdminId.Text.Trim());
                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                ShowMessage("✅ Admin updated successfully!", true);
                ClearFields();
                LoadGrid();
            }
            catch (Exception ex)
            {
                ShowMessage("❌ Error: " + ex.Message, false);
            }
        }

        // =====================================================================
        //  CLEAR
        // =====================================================================
        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearFields();
            lblMessage.Visible = false;
        }

        // =====================================================================
        //  GridView RowCommand — SelectRow & DeleteRow
        // =====================================================================
        protected void gvAdmins_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            int adminId = Convert.ToInt32(e.CommandArgument);

            // ── EDIT: fill form with selected row ────────────────────────
            if (e.CommandName == "SelectRow")
            {
                try
                {
                    using (SqlConnection con = new SqlConnection(connStr))
                    {
                        SqlCommand cmd = new SqlCommand("SELECT * FROM Admins WHERE AdminId=@id", con);
                        cmd.Parameters.AddWithValue("@id", adminId);

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            DataRow row = dt.Rows[0];
                            txtAdminId.Text = row["AdminId"].ToString();
                            txtUsername.Text = row["Username"].ToString();
                            txtEmail.Text = row["Email"].ToString();
                            txtPassword.Text = row["Password"].ToString();
                            ddlRole.SelectedValue = row["Role"].ToString();
                            lblMessage.Visible = false;
                        }
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("❌ Error: " + ex.Message, false);
                }
            }

            // ── DELETE ───────────────────────────────────────────────────
            else if (e.CommandName == "DeleteRow")
            {
                try
                {
                    using (SqlConnection con = new SqlConnection(connStr))
                    {
                        SqlCommand cmd = new SqlCommand("DELETE FROM Admins WHERE AdminId=@id", con);
                        cmd.Parameters.AddWithValue("@id", adminId);
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }

                    ShowMessage("🗑️ Admin deleted successfully!", true);
                    ClearFields();
                    LoadGrid();
                }
                catch (Exception ex)
                {
                    ShowMessage("❌ Error: " + ex.Message, false);
                }
            }
        }

        // =====================================================================
        //  Helpers
        // =====================================================================
        private void ClearFields()
        {
            txtAdminId.Text = txtUsername.Text = txtEmail.Text = txtPassword.Text = "";
            ddlRole.SelectedIndex = 0;
        }

        private bool ValidateFields()
        {
            if (string.IsNullOrEmpty(txtUsername.Text.Trim()))
            { ShowMessage("⚠️ Username is required.", false); return false; }
            if (string.IsNullOrEmpty(txtEmail.Text.Trim()))
            { ShowMessage("⚠️ Email is required.", false); return false; }
            if (string.IsNullOrEmpty(txtPassword.Text.Trim()))
            { ShowMessage("⚠️ Password is required.", false); return false; }
            if (string.IsNullOrEmpty(ddlRole.SelectedValue))
            { ShowMessage("⚠️ Please select a Role.", false); return false; }
            return true;
        }

        private void ShowMessage(string msg, bool success)
        {
            lblMessage.Text = msg;
            lblMessage.CssClass = success ? "alert msg-success" : "alert msg-error";
            lblMessage.Visible = true;
        }

        // Called from GridView TemplateField
        public string GetRoleBadge(string role)
        {
            switch (role)
            {
                case "SuperAdmin": return "role-super";
                case "CityAdmin": return "role-city";
                case "VenueManager": return "role-venue";
                default: return "role-super";
            }
        }
    }
}