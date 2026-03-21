using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace EventGlint.Admin
{
    public partial class EditHalls : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null) { Response.Redirect("~/Log.aspx"); return; }
            lbl_AvatarInitial.Text = (Session["Username"]?.ToString() ?? "A")[0].ToString().ToUpper();
            if (!IsPostBack) { BindVenues(); LoadGrid(); }
        }

        private void BindVenues()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter("SELECT VenueId, Name FROM Venues ORDER BY Name", con);
                    DataTable dt = new DataTable(); da.Fill(dt);
                    ddlVenueId.DataSource = dt;
                    ddlVenueId.DataValueField = "VenueId";
                    ddlVenueId.DataTextField = "Name";
                    ddlVenueId.DataBind();
                    ddlVenueId.Items.Insert(0, new ListItem("-- Select Venue --", ""));
                }
            }
            catch { ddlVenueId.Items.Insert(0, new ListItem("-- Error --", "")); }
        }

        private void LoadGrid()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter(@"SELECT h.HallId, v.Name AS VenueName, h.Name, h.HallType, h.TotalCapacity
                        FROM Halls h JOIN Venues v ON v.VenueId=h.VenueId ORDER BY v.Name, h.Name", con);
                    DataTable dt = new DataTable(); da.Fill(dt);
                    gvHalls.DataSource = dt; gvHalls.DataBind();
                    lblCount.Text = dt.Rows.Count + " record(s)";
                }
            }
            catch (Exception ex) { ShowMessage("❌ " + ex.Message, false); }
        }

        private string GetHallType()
        {
            if (rb2D.Checked) return "2D";
            if (rb3D.Checked) return "3D";
            if (rbIMAX.Checked) return "IMAX";
            if (rb4DX.Checked) return "4DX";
            if (rbDolby.Checked) return "Dolby";
            return "";
        }

        private void SetHallType(string t)
        {
            rb2D.Checked = t == "2D"; rb3D.Checked = t == "3D";
            rbIMAX.Checked = t == "IMAX"; rb4DX.Checked = t == "4DX"; rbDolby.Checked = t == "Dolby";
        }

        protected void btnInsert_Click(object sender, EventArgs e)
        {
            if (!Validate()) return;
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("INSERT INTO Halls(VenueId,Name,HallType,TotalCapacity) VALUES(@vid,@n,@ht,@cap)", con);
                    cmd.Parameters.AddWithValue("@vid", int.Parse(ddlVenueId.SelectedValue));
                    cmd.Parameters.AddWithValue("@n", txtHallName.Text.Trim());
                    cmd.Parameters.AddWithValue("@ht", GetHallType());
                    cmd.Parameters.AddWithValue("@cap", int.Parse(txtCapacity.Text));
                    con.Open(); cmd.ExecuteNonQuery();
                }
                ShowMessage("✅ Hall inserted!", true); ClearFields(); LoadGrid();
            }
            catch (Exception ex) { ShowMessage("❌ " + ex.Message, false); }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtHallId.Text)) { ShowMessage("⚠️ Select a record first.", false); return; }
            if (!Validate()) return;
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("UPDATE Halls SET VenueId=@vid,Name=@n,HallType=@ht,TotalCapacity=@cap WHERE HallId=@id", con);
                    cmd.Parameters.AddWithValue("@vid", int.Parse(ddlVenueId.SelectedValue));
                    cmd.Parameters.AddWithValue("@n", txtHallName.Text.Trim());
                    cmd.Parameters.AddWithValue("@ht", GetHallType());
                    cmd.Parameters.AddWithValue("@cap", int.Parse(txtCapacity.Text));
                    cmd.Parameters.AddWithValue("@id", int.Parse(txtHallId.Text));
                    con.Open(); cmd.ExecuteNonQuery();
                }
                ShowMessage("✅ Hall updated!", true); ClearFields(); LoadGrid();
            }
            catch (Exception ex) { ShowMessage("❌ " + ex.Message, false); }
        }

        protected void btnClear_Click(object sender, EventArgs e) { ClearFields(); lblMessage.Visible = false; }

        protected void gvHalls_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "SelectRow")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Halls WHERE HallId=@id", con);
                    da.SelectCommand.Parameters.AddWithValue("@id", id);
                    DataTable dt = new DataTable(); da.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        DataRow r = dt.Rows[0];
                        txtHallId.Text = r["HallId"].ToString();
                        ddlVenueId.SelectedValue = r["VenueId"].ToString();
                        txtHallName.Text = r["Name"].ToString();
                        SetHallType(r["HallType"].ToString());
                        txtCapacity.Text = r["TotalCapacity"].ToString();
                        lblMessage.Visible = false;
                    }
                }
            }
            else if (e.CommandName == "DeleteRow")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("DELETE FROM Halls WHERE HallId=@id", con);
                    cmd.Parameters.AddWithValue("@id", id); con.Open(); cmd.ExecuteNonQuery();
                }
                ShowMessage("🗑️ Hall deleted!", true); ClearFields(); LoadGrid();
            }
        }

        private void ClearFields() { txtHallId.Text = txtHallName.Text = txtCapacity.Text = ""; ddlVenueId.SelectedIndex = 0; rb2D.Checked = false; rb3D.Checked = false; rbIMAX.Checked = false; rb4DX.Checked = false; rbDolby.Checked = false; }
        private bool Validate()
        {
            if (string.IsNullOrEmpty(ddlVenueId.SelectedValue)) { ShowMessage("⚠️ Select Venue.", false); return false; }
            if (string.IsNullOrEmpty(txtHallName.Text.Trim())) { ShowMessage("⚠️ Hall Name required.", false); return false; }
            if (string.IsNullOrEmpty(GetHallType())) { ShowMessage("⚠️ Select Hall Type.", false); return false; }
            if (string.IsNullOrEmpty(txtCapacity.Text.Trim())) { ShowMessage("⚠️ Capacity required.", false); return false; }
            return true;
        }
        private void ShowMessage(string msg, bool ok) { lblMessage.Text = msg; lblMessage.CssClass = ok ? "alert msg-success" : "alert msg-error"; lblMessage.Visible = true; }
    }
}