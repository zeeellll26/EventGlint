using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace EventGlint.Admin
{
    public partial class EditVenue : System.Web.UI.Page
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
                    // Existing venues (to select for editing)
                    SqlDataAdapter da = new SqlDataAdapter("SELECT VenueId, Name FROM Venues ORDER BY Name", con);
                    DataTable dt = new DataTable(); da.Fill(dt);
                    ddlVenueName.DataSource = dt; ddlVenueName.DataValueField = "VenueId"; ddlVenueName.DataTextField = "Name"; ddlVenueName.DataBind();
                    ddlVenueName.Items.Insert(0, new ListItem("-- New Venue --", "0"));

                    // Cities
                    da = new SqlDataAdapter("SELECT CityId, Name + ', ' + State AS Label FROM Cities ORDER BY Name", con);
                    dt = new DataTable(); da.Fill(dt);
                    ddlCityId.DataSource = dt; ddlCityId.DataValueField = "CityId"; ddlCityId.DataTextField = "Label"; ddlCityId.DataBind();
                    ddlCityId.Items.Insert(0, new ListItem("-- Select City --", ""));
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
                        SELECT v.VenueId, v.Name, c.Name AS CityName,
                               v.Address, v.Phone, v.CreatedAt
                        FROM Venues v JOIN Cities c ON c.CityId = v.CityId
                        ORDER BY v.VenueId DESC", con);
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
            // For new venue, need a name — use a popup textbox approach; 
            // here we require the user to type the name in address field placeholder
            // Better: use VenueName dropdown label as name when value=0
            string vname = ddlVenueName.SelectedValue == "0"
                ? "New Venue"  // default — admin can rename with Save
                : ddlVenueName.SelectedItem.Text;
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(@"
                        INSERT INTO Venues(Name,CityId,Address,Phone,Email,Amenities,Images,CreatedAt)
                        VALUES(@n,@cid,@addr,@ph,@em,@am,@img,GETDATE())", con);
                    cmd.Parameters.AddWithValue("@n", vname);
                    SetCommonParams(cmd);
                    con.Open(); cmd.ExecuteNonQuery();
                }
                ShowMessage("✅ Venue inserted!", true); ClearFields(); BindDropdowns(); LoadGrid();
            }
            catch (Exception ex) { ShowMessage("❌ " + ex.Message, false); }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtVenueId.Text)) { ShowMessage("⚠️ Select a record first.", false); return; }
            if (!Validate()) return;
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(@"
                        UPDATE Venues SET CityId=@cid,Address=@addr,Phone=@ph,
                        Email=@em,Amenities=@am,Images=@img WHERE VenueId=@id", con);
                    SetCommonParams(cmd);
                    cmd.Parameters.AddWithValue("@id", int.Parse(txtVenueId.Text));
                    con.Open(); cmd.ExecuteNonQuery();
                }
                ShowMessage("✅ Venue updated!", true); ClearFields(); BindDropdowns(); LoadGrid();
            }
            catch (Exception ex) { ShowMessage("❌ " + ex.Message, false); }
        }

        private void SetCommonParams(SqlCommand cmd)
        {
            cmd.Parameters.AddWithValue("@cid", int.Parse(ddlCityId.SelectedValue));
            cmd.Parameters.AddWithValue("@addr", txtAddress.Text.Trim());
            cmd.Parameters.AddWithValue("@ph", txtPhone.Text.Trim());
            cmd.Parameters.AddWithValue("@em", txtEmail.Text.Trim());
            cmd.Parameters.AddWithValue("@am", txtAmenities.Text.Trim());
            cmd.Parameters.AddWithValue("@img", txtImages.Text.Trim());
        }

        protected void btnClear_Click(object sender, EventArgs e) { ClearFields(); lblMessage.Visible = false; }

        protected void gvData_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "SelectRow")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Venues WHERE VenueId=@id", con);
                    da.SelectCommand.Parameters.AddWithValue("@id", id);
                    DataTable dt = new DataTable(); da.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        DataRow r = dt.Rows[0];
                        txtVenueId.Text = r["VenueId"].ToString();
                        ddlVenueName.SelectedValue = r["VenueId"].ToString();
                        ddlCityId.SelectedValue = r["CityId"].ToString();
                        txtAddress.Text = r["Address"]?.ToString();
                        txtPhone.Text = r["Phone"]?.ToString();
                        txtEmail.Text = r["Email"]?.ToString();
                        txtAmenities.Text = r["Amenities"]?.ToString();
                        txtImages.Text = r["Images"]?.ToString();
                        lblMessage.Visible = false;
                    }
                }
            }
            else if (e.CommandName == "DeleteRow")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                { SqlCommand cmd = new SqlCommand("DELETE FROM Venues WHERE VenueId=@id", con); cmd.Parameters.AddWithValue("@id", id); con.Open(); cmd.ExecuteNonQuery(); }
                ShowMessage("🗑️ Venue deleted!", true); ClearFields(); BindDropdowns(); LoadGrid();
            }
        }

        private void ClearFields() { txtVenueId.Text = txtAddress.Text = txtPhone.Text = txtEmail.Text = txtAmenities.Text = txtImages.Text = ""; ddlVenueName.SelectedIndex = 0; ddlCityId.SelectedIndex = 0; }
        private bool Validate()
        {
            if (string.IsNullOrEmpty(ddlCityId.SelectedValue)) { ShowMessage("⚠️ Select City.", false); return false; }
            if (string.IsNullOrEmpty(txtAddress.Text.Trim())) { ShowMessage("⚠️ Address required.", false); return false; }
            return true;
        }
        private void ShowMessage(string msg, bool ok) { lblMessage.Text = msg; lblMessage.CssClass = ok ? "alert msg-success" : "alert msg-error"; lblMessage.Visible = true; }
    }
}