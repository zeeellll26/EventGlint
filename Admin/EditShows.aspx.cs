using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace EventGlint.Admin
{
    public partial class EditShows : System.Web.UI.Page
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
                    // Events
                    SqlDataAdapter da = new SqlDataAdapter("SELECT EventId, Title + ' (' + EventType + ')' AS Label FROM Events ORDER BY Title", con);
                    DataTable dt = new DataTable(); da.Fill(dt);
                    ddlEventId.DataSource = dt; ddlEventId.DataValueField = "EventId"; ddlEventId.DataTextField = "Label"; ddlEventId.DataBind();
                    ddlEventId.Items.Insert(0, new ListItem("-- Select Event --", ""));

                    // Halls
                    da = new SqlDataAdapter("SELECT h.HallId, v.Name + ' - ' + h.Name + ' (' + h.HallType + ')' AS Label FROM Halls h JOIN Venues v ON v.VenueId=h.VenueId ORDER BY v.Name, h.Name", con);
                    dt = new DataTable(); da.Fill(dt);
                    ddlHallId.DataSource = dt; ddlHallId.DataValueField = "HallId"; ddlHallId.DataTextField = "Label"; ddlHallId.DataBind();
                    ddlHallId.Items.Insert(0, new ListItem("-- Select Hall --", ""));
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
                    SqlDataAdapter da = new SqlDataAdapter(@"
                        SELECT sh.ShowId, e.Title AS EventTitle,
                               v.Name + ' - ' + h.Name AS HallName,
                               sh.ShowDate, sh.StartTime, sh.Status
                        FROM Shows sh
                        JOIN Events e ON e.EventId = sh.EventId
                        JOIN Halls h  ON h.HallId  = sh.HallId
                        JOIN Venues v ON v.VenueId = h.VenueId
                        ORDER BY sh.ShowDate DESC, sh.StartTime", con);
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
                    SqlCommand cmd = new SqlCommand("INSERT INTO Shows(EventId,HallId,ShowDate,StartTime,EndTime,Status,CreatedAt) VALUES(@eid,@hid,@sd,@st,@et,@s,GETDATE())", con);
                    SetParams(cmd); con.Open(); cmd.ExecuteNonQuery();
                }
                ShowMessage("✅ Show inserted!", true); ClearFields(); LoadGrid();
            }
            catch (Exception ex) { ShowMessage("❌ " + ex.Message, false); }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtShowId.Text)) { ShowMessage("⚠️ Select a record first.", false); return; }
            if (!Validate()) return;
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("UPDATE Shows SET EventId=@eid,HallId=@hid,ShowDate=@sd,StartTime=@st,EndTime=@et,Status=@s WHERE ShowId=@id", con);
                    SetParams(cmd); cmd.Parameters.AddWithValue("@id", int.Parse(txtShowId.Text));
                    con.Open(); cmd.ExecuteNonQuery();
                }
                ShowMessage("✅ Show updated!", true); ClearFields(); LoadGrid();
            }
            catch (Exception ex) { ShowMessage("❌ " + ex.Message, false); }
        }

        private void SetParams(SqlCommand cmd)
        {
            cmd.Parameters.AddWithValue("@eid", int.Parse(ddlEventId.SelectedValue));
            cmd.Parameters.AddWithValue("@hid", int.Parse(ddlHallId.SelectedValue));
            cmd.Parameters.AddWithValue("@sd", DateTime.Parse(txtShowDate.Text));
            cmd.Parameters.AddWithValue("@st", txtStartTime.Text);
            cmd.Parameters.AddWithValue("@et", string.IsNullOrEmpty(txtEndTime.Text) ? (object)DBNull.Value : txtEndTime.Text);
            cmd.Parameters.AddWithValue("@s", ddlStatus.SelectedValue);
        }

        protected void btnClear_Click(object sender, EventArgs e) { ClearFields(); lblMessage.Visible = false; }

        protected void gvData_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "SelectRow")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Shows WHERE ShowId=@id", con);
                    da.SelectCommand.Parameters.AddWithValue("@id", id);
                    DataTable dt = new DataTable(); da.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        DataRow r = dt.Rows[0];
                        txtShowId.Text = r["ShowId"].ToString();
                        ddlEventId.SelectedValue = r["EventId"].ToString();
                        ddlHallId.SelectedValue = r["HallId"].ToString();
                        txtShowDate.Text = Convert.ToDateTime(r["ShowDate"]).ToString("yyyy-MM-dd");
                        txtStartTime.Text = r["StartTime"].ToString();
                        txtEndTime.Text = r["EndTime"] == DBNull.Value ? "" : r["EndTime"].ToString();
                        ddlStatus.SelectedValue = r["Status"].ToString();
                        lblMessage.Visible = false;
                    }
                }
            }
            else if (e.CommandName == "DeleteRow")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                { SqlCommand cmd = new SqlCommand("DELETE FROM Shows WHERE ShowId=@id", con); cmd.Parameters.AddWithValue("@id", id); con.Open(); cmd.ExecuteNonQuery(); }
                ShowMessage("🗑️ Show deleted!", true); ClearFields(); LoadGrid();
            }
        }

        private void ClearFields() { txtShowId.Text = txtShowDate.Text = txtStartTime.Text = txtEndTime.Text = ""; ddlEventId.SelectedIndex = ddlHallId.SelectedIndex = ddlStatus.SelectedIndex = 0; }
        private bool Validate()
        {
            if (string.IsNullOrEmpty(ddlEventId.SelectedValue)) { ShowMessage("⚠️ Select Event.", false); return false; }
            if (string.IsNullOrEmpty(ddlHallId.SelectedValue)) { ShowMessage("⚠️ Select Hall.", false); return false; }
            if (string.IsNullOrEmpty(txtShowDate.Text)) { ShowMessage("⚠️ Show Date required.", false); return false; }
            if (string.IsNullOrEmpty(txtStartTime.Text)) { ShowMessage("⚠️ Start Time required.", false); return false; }
            if (string.IsNullOrEmpty(ddlStatus.SelectedValue)) { ShowMessage("⚠️ Select Status.", false); return false; }
            return true;
        }
        private void ShowMessage(string msg, bool ok) { lblMessage.Text = msg; lblMessage.CssClass = ok ? "alert msg-success" : "alert msg-error"; lblMessage.Visible = true; }
    }
}