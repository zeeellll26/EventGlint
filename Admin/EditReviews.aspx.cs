using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace EventGlint.Admin
{
    public partial class EditReviews : System.Web.UI.Page
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
                    // Users
                    SqlDataAdapter da = new SqlDataAdapter("SELECT UserId, Username FROM Users ORDER BY Username", con);
                    DataTable dt = new DataTable(); da.Fill(dt);
                    ddlUserId.DataSource = dt; ddlUserId.DataValueField = "UserId"; ddlUserId.DataTextField = "Username"; ddlUserId.DataBind();
                    ddlUserId.Items.Insert(0, new ListItem("-- Select User --", ""));
                    // Events
                    da = new SqlDataAdapter("SELECT EventId, Title FROM Events ORDER BY Title", con);
                    dt = new DataTable(); da.Fill(dt);
                    ddlEventId.DataSource = dt; ddlEventId.DataValueField = "EventId"; ddlEventId.DataTextField = "Title"; ddlEventId.DataBind();
                    ddlEventId.Items.Insert(0, new ListItem("-- Select Event --", ""));
                }
            }
            catch { }
        }
        private void LoadGrid()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter(@"SELECT r.ReviewId, u.Username AS UserName, e.Title AS EventTitle, r.Rating, r.ReviewText, r.CreatedAt
                        FROM Reviews r JOIN Users u ON u.UserId=r.UserId JOIN Events e ON e.EventId=r.EventId ORDER BY r.ReviewId DESC", con);
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
                    SqlCommand cmd = new SqlCommand("INSERT INTO Reviews(UserId,EventId,Rating,ReviewText,CreatedAt) VALUES(@uid,@eid,@rat,@txt,GETDATE())", con);
                    cmd.Parameters.AddWithValue("@uid", int.Parse(ddlUserId.SelectedValue));
                    cmd.Parameters.AddWithValue("@eid", int.Parse(ddlEventId.SelectedValue));
                    cmd.Parameters.AddWithValue("@rat", int.Parse(ddlRating.SelectedValue));
                    cmd.Parameters.AddWithValue("@txt", txtReviewText.Text.Trim());
                    con.Open(); cmd.ExecuteNonQuery();
                }
                ShowMessage("✅ Review inserted!", true); ClearFields(); LoadGrid();
            }
            catch (Exception ex) { ShowMessage("❌ " + ex.Message, false); }
        }
        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtReviewId.Text)) { ShowMessage("⚠️ Select a record first.", false); return; }
            if (!Validate()) return;
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("UPDATE Reviews SET UserId=@uid,EventId=@eid,Rating=@rat,ReviewText=@txt WHERE ReviewId=@id", con);
                    cmd.Parameters.AddWithValue("@uid", int.Parse(ddlUserId.SelectedValue));
                    cmd.Parameters.AddWithValue("@eid", int.Parse(ddlEventId.SelectedValue));
                    cmd.Parameters.AddWithValue("@rat", int.Parse(ddlRating.SelectedValue));
                    cmd.Parameters.AddWithValue("@txt", txtReviewText.Text.Trim());
                    cmd.Parameters.AddWithValue("@id", int.Parse(txtReviewId.Text));
                    con.Open(); cmd.ExecuteNonQuery();
                }
                ShowMessage("✅ Review updated!", true); ClearFields(); LoadGrid();
            }
            catch (Exception ex) { ShowMessage("❌ " + ex.Message, false); }
        }
        protected void btnClear_Click(object sender, EventArgs e) { ClearFields(); lblMessage.Visible = false; }
        protected void gvData_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "SelectRow")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Reviews WHERE ReviewId=@id", con);
                    da.SelectCommand.Parameters.AddWithValue("@id", id);
                    DataTable dt = new DataTable(); da.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        DataRow r = dt.Rows[0];
                        txtReviewId.Text = r["ReviewId"].ToString();
                        ddlUserId.SelectedValue = r["UserId"].ToString();
                        ddlEventId.SelectedValue = r["EventId"].ToString();
                        ddlRating.SelectedValue = r["Rating"].ToString();
                        txtReviewText.Text = r["ReviewText"].ToString();
                        lblMessage.Visible = false;
                    }
                }
            }
            else if (e.CommandName == "DeleteRow")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                { SqlCommand cmd = new SqlCommand("DELETE FROM Reviews WHERE ReviewId=@id", con); cmd.Parameters.AddWithValue("@id", id); con.Open(); cmd.ExecuteNonQuery(); }
                ShowMessage("🗑️ Review deleted!", true); ClearFields(); LoadGrid();
            }
        }
        private void ClearFields() { txtReviewId.Text = txtReviewText.Text = ""; ddlUserId.SelectedIndex = ddlEventId.SelectedIndex = ddlRating.SelectedIndex = 0; }
        private bool Validate() { if (string.IsNullOrEmpty(ddlUserId.SelectedValue)) { ShowMessage("⚠️ Select User.", false); return false; } if (string.IsNullOrEmpty(ddlEventId.SelectedValue)) { ShowMessage("⚠️ Select Event.", false); return false; } if (string.IsNullOrEmpty(ddlRating.SelectedValue)) { ShowMessage("⚠️ Select Rating.", false); return false; } return true; }
        private void ShowMessage(string msg, bool ok) { lblMessage.Text = msg; lblMessage.CssClass = ok ? "alert msg-success" : "alert msg-error"; lblMessage.Visible = true; }
    }
}