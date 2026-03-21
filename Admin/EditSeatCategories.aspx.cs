using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace EventGlint.Admin
{
    public partial class EditSeatCategories : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null) { Response.Redirect("~/Log.aspx"); return; }
            lbl_AvatarInitial.Text = (Session["Username"]?.ToString() ?? "A")[0].ToString().ToUpper();
            if (!IsPostBack) { BindHalls(); LoadGrid(); }
        }

        private void BindHalls()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter(
                        "SELECT h.HallId, v.Name + ' - ' + h.Name AS Label FROM Halls h JOIN Venues v ON v.VenueId=h.VenueId ORDER BY v.Name, h.Name", con);
                    DataTable dt = new DataTable(); da.Fill(dt);
                    ddlHallId.DataSource = dt; ddlHallId.DataValueField = "HallId"; ddlHallId.DataTextField = "Label"; ddlHallId.DataBind();
                    ddlHallId.Items.Insert(0, new ListItem("-- Select Hall --", ""));
                }
            }
            catch { ddlHallId.Items.Insert(0, new ListItem("-- Error --", "")); }
        }

        private void LoadGrid()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter(@"SELECT sc.CategoryId, v.Name + ' - ' + h.Name AS HallName, sc.Name, sc.Price, sc.ColorCode
                        FROM SeatCategories sc JOIN Halls h ON h.HallId=sc.HallId JOIN Venues v ON v.VenueId=h.VenueId ORDER BY sc.CategoryId DESC", con);
                    DataTable dt = new DataTable(); da.Fill(dt);
                    gvData.DataSource = dt; gvData.DataBind();
                    lblCount.Text = dt.Rows.Count + " record(s)";
                }
            }
            catch (Exception ex) { ShowMessage("❌ " + ex.Message, false); }
        }

        private string GetCatName() { if (rbSilver.Checked) return "Silver"; if (rbGold.Checked) return "Gold"; if (rbPlatinum.Checked) return "Platinum"; return ""; }
        private void SetCatName(string n) { rbSilver.Checked = n == "Silver"; rbGold.Checked = n == "Gold"; rbPlatinum.Checked = n == "Platinum"; }

        protected void btnInsert_Click(object sender, EventArgs e)
        {
            if (!Validate()) return;
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("INSERT INTO SeatCategories(HallId,Name,Price,ColorCode) VALUES(@hid,@n,@p,@cc)", con);
                    cmd.Parameters.AddWithValue("@hid", int.Parse(ddlHallId.SelectedValue));
                    cmd.Parameters.AddWithValue("@n", GetCatName());
                    cmd.Parameters.AddWithValue("@p", decimal.Parse(txtPrice.Text));
                    cmd.Parameters.AddWithValue("@cc", txtColorCode.Text.Trim());
                    con.Open(); cmd.ExecuteNonQuery();
                }
                ShowMessage("✅ Category inserted!", true); ClearFields(); LoadGrid();
            }
            catch (Exception ex) { ShowMessage("❌ " + ex.Message, false); }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtCategoryId.Text)) { ShowMessage("⚠️ Select a record first.", false); return; }
            if (!Validate()) return;
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("UPDATE SeatCategories SET HallId=@hid,Name=@n,Price=@p,ColorCode=@cc WHERE CategoryId=@id", con);
                    cmd.Parameters.AddWithValue("@hid", int.Parse(ddlHallId.SelectedValue));
                    cmd.Parameters.AddWithValue("@n", GetCatName());
                    cmd.Parameters.AddWithValue("@p", decimal.Parse(txtPrice.Text));
                    cmd.Parameters.AddWithValue("@cc", txtColorCode.Text.Trim());
                    cmd.Parameters.AddWithValue("@id", int.Parse(txtCategoryId.Text));
                    con.Open(); cmd.ExecuteNonQuery();
                }
                ShowMessage("✅ Category updated!", true); ClearFields(); LoadGrid();
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
                    SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM SeatCategories WHERE CategoryId=@id", con);
                    da.SelectCommand.Parameters.AddWithValue("@id", id);
                    DataTable dt = new DataTable(); da.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        DataRow r = dt.Rows[0];
                        txtCategoryId.Text = r["CategoryId"].ToString();
                        ddlHallId.SelectedValue = r["HallId"].ToString();
                        SetCatName(r["Name"].ToString());
                        txtPrice.Text = r["Price"].ToString();
                        txtColorCode.Text = r["ColorCode"]?.ToString();
                        lblMessage.Visible = false;
                    }
                }
            }
            else if (e.CommandName == "DeleteRow")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                { SqlCommand cmd = new SqlCommand("DELETE FROM SeatCategories WHERE CategoryId=@id", con); cmd.Parameters.AddWithValue("@id", id); con.Open(); cmd.ExecuteNonQuery(); }
                ShowMessage("🗑️ Category deleted!", true); ClearFields(); LoadGrid();
            }
        }

        private void ClearFields() { txtCategoryId.Text = txtPrice.Text = txtColorCode.Text = ""; ddlHallId.SelectedIndex = 0; rbSilver.Checked = rbGold.Checked = rbPlatinum.Checked = false; }
        private bool Validate()
        {
            if (string.IsNullOrEmpty(ddlHallId.SelectedValue)) { ShowMessage("⚠️ Select Hall.", false); return false; }
            if (string.IsNullOrEmpty(GetCatName())) { ShowMessage("⚠️ Select Category Name.", false); return false; }
            if (string.IsNullOrEmpty(txtPrice.Text.Trim())) { ShowMessage("⚠️ Price required.", false); return false; }
            return true;
        }
        private void ShowMessage(string msg, bool ok) { lblMessage.Text = msg; lblMessage.CssClass = ok ? "alert msg-success" : "alert msg-error"; lblMessage.Visible = true; }
    }
}