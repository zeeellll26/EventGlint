using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace EventGlint.Admin
{
    public partial class EditEvents : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null) { Response.Redirect("~/Log.aspx"); return; }
            lbl_AvatarInitial.Text = (Session["Username"]?.ToString() ?? "A")[0].ToString().ToUpper();
            if (!IsPostBack) { BindDropdowns(); LoadGrid(); }
        }

        private void BindDropdowns()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter("SELECT AdminId, Username FROM Admins ORDER BY Username", con);
                    DataTable dt = new DataTable(); da.Fill(dt);
                    ddlCreatedBy.DataSource = dt;
                    ddlCreatedBy.DataValueField = "AdminId";
                    ddlCreatedBy.DataTextField = "Username";
                    ddlCreatedBy.DataBind();
                    ddlCreatedBy.Items.Insert(0, new ListItem("-- Select Admin --", ""));
                }
            }
            catch { ddlCreatedBy.Items.Insert(0, new ListItem("-- Error --", "")); }
        }

        private void LoadGrid()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter("SELECT EventId,Title,EventType,Language,DurationMins,ReleaseDate FROM Events ORDER BY EventId DESC", con);
                    DataTable dt = new DataTable(); da.Fill(dt);
                    gvEvents.DataSource = dt; gvEvents.DataBind();
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
                    SqlCommand cmd = new SqlCommand(@"INSERT INTO Events(Title,EventType,Description,DurationMins,Language,Genre,ReleaseDate,EndDate,CreatedAt,CreatedBy)
                        VALUES(@t,@et,@d,@dm,@l,@g,@rd,@ed,GETDATE(),@cb)", con);
                    SetParams(cmd);
                    con.Open(); cmd.ExecuteNonQuery();
                }
                ShowMessage("✅ Event inserted!", true); ClearFields(); LoadGrid();
            }
            catch (Exception ex) { ShowMessage("❌ " + ex.Message, false); }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtEventId.Text)) { ShowMessage("⚠️ Select a record first.", false); return; }
            if (!Validate()) return;
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(@"UPDATE Events SET Title=@t,EventType=@et,Description=@d,DurationMins=@dm,
                        Language=@l,Genre=@g,ReleaseDate=@rd,EndDate=@ed,CreatedBy=@cb WHERE EventId=@id", con);
                    SetParams(cmd);
                    cmd.Parameters.AddWithValue("@id", int.Parse(txtEventId.Text));
                    con.Open(); cmd.ExecuteNonQuery();
                }
                ShowMessage("✅ Event updated!", true); ClearFields(); LoadGrid();
            }
            catch (Exception ex) { ShowMessage("❌ " + ex.Message, false); }
        }

        private void SetParams(SqlCommand cmd)
        {
            cmd.Parameters.AddWithValue("@t", txtTitle.Text.Trim());
            cmd.Parameters.AddWithValue("@et", ddlEventType.SelectedValue);
            cmd.Parameters.AddWithValue("@d", txtDescription.Text.Trim());
            cmd.Parameters.AddWithValue("@dm", string.IsNullOrEmpty(txtDuration.Text) ? (object)DBNull.Value : int.Parse(txtDuration.Text));
            cmd.Parameters.AddWithValue("@l", txtLanguage.Text.Trim());
            cmd.Parameters.AddWithValue("@g", txtGenre.Text.Trim());
            cmd.Parameters.AddWithValue("@rd", string.IsNullOrEmpty(txtReleaseDate.Text) ? (object)DBNull.Value : DateTime.Parse(txtReleaseDate.Text));
            cmd.Parameters.AddWithValue("@ed", string.IsNullOrEmpty(txtEndDate.Text) ? (object)DBNull.Value : DateTime.Parse(txtEndDate.Text));
            cmd.Parameters.AddWithValue("@cb", string.IsNullOrEmpty(ddlCreatedBy.SelectedValue) ? (object)DBNull.Value : int.Parse(ddlCreatedBy.SelectedValue));
        }

        protected void btnClear_Click(object sender, EventArgs e) { ClearFields(); lblMessage.Visible = false; }

        protected void gvEvents_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "SelectRow")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Events WHERE EventId=@id", con);
                    da.SelectCommand.Parameters.AddWithValue("@id", id);
                    DataTable dt = new DataTable(); da.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        DataRow r = dt.Rows[0];
                        txtEventId.Text = r["EventId"].ToString();
                        txtTitle.Text = r["Title"].ToString();
                        ddlEventType.SelectedValue = r["EventType"].ToString();
                        txtDescription.Text = r["Description"].ToString();
                        txtDuration.Text = r["DurationMins"].ToString();
                        txtLanguage.Text = r["Language"].ToString();
                        txtGenre.Text = r["Genre"].ToString();
                        if (r["ReleaseDate"] != DBNull.Value) txtReleaseDate.Text = Convert.ToDateTime(r["ReleaseDate"]).ToString("yyyy-MM-dd");
                        if (r["EndDate"] != DBNull.Value) txtEndDate.Text = Convert.ToDateTime(r["EndDate"]).ToString("yyyy-MM-dd");
                        if (r["CreatedBy"] != DBNull.Value) ddlCreatedBy.SelectedValue = r["CreatedBy"].ToString();
                        lblMessage.Visible = false;
                    }
                }
            }
            else if (e.CommandName == "DeleteRow")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("DELETE FROM Events WHERE EventId=@id", con);
                    cmd.Parameters.AddWithValue("@id", id); con.Open(); cmd.ExecuteNonQuery();
                }
                ShowMessage("🗑️ Event deleted!", true); ClearFields(); LoadGrid();
            }
        }

        private void ClearFields()
        {
            txtEventId.Text = txtTitle.Text = txtDescription.Text = txtDuration.Text =
            txtLanguage.Text = txtGenre.Text = txtReleaseDate.Text = txtEndDate.Text = "";
            ddlEventType.SelectedIndex = 0; ddlCreatedBy.SelectedIndex = 0;
        }
        private bool Validate()
        {
            if (string.IsNullOrEmpty(txtTitle.Text.Trim())) { ShowMessage("⚠️ Title required.", false); return false; }
            if (string.IsNullOrEmpty(ddlEventType.SelectedValue)) { ShowMessage("⚠️ Event Type required.", false); return false; }
            return true;
        }
        private void ShowMessage(string msg, bool ok) { lblMessage.Text = msg; lblMessage.CssClass = ok ? "alert msg-success" : "alert msg-error"; lblMessage.Visible = true; }
    }
}