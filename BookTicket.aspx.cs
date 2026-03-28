using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EventGlint
{
    public partial class BookTicket : System.Web.UI.Page
    {
        string connStr = System.Configuration.ConfigurationManager
                              .ConnectionStrings["dbconnection"].ConnectionString;

        int eventId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Session guard
            if (Session["Username"] == null)
            {
                Response.Redirect("Log.aspx");
                return;
            }

            // Get EventId from query string
            if (!int.TryParse(Request.QueryString["EventId"], out eventId) || eventId == 0)
            {
                Response.Redirect("Home.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUserInfo();
                LoadEventDetails();
                LoadShows();
                SetStepUI(1);   // Start at step 1
            }
        }

        // ── Fill sidebar labels ───────────────────────────────────────────
        private void LoadUserInfo()
        {
            string username = Session["Username"].ToString();
            lblUserName.Text = username;
            lblUserRole.Text = "Member";
            lblAvatarInitial.Text = username.Substring(0, 1).ToUpper();
            lblTopAvatar.Text = username.Substring(0, 1).ToUpper();
        }

        // ── Load event info from DB ───────────────────────────────────────
        private void LoadEventDetails()
        {
            SqlConnection con = new SqlConnection(connStr);
            SqlCommand cmd = new SqlCommand(
                "SELECT Title, EventType, Language, DurationMins, Description FROM Events WHERE EventId = @id", con);
            cmd.Parameters.AddWithValue("@id", eventId);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            if (dt.Rows.Count == 0) return;

            DataRow r = dt.Rows[0];

            lblEventTitle.Text = r["Title"].ToString();
            lblEventType.Text = r["EventType"].ToString();
            lblLanguage.Text = r["Language"].ToString();
            //lblRating.Text = r["CensorRating"].ToString();
            lblDuration.Text = r["DurationMins"].ToString();
            lblDescription.Text = r["Description"].ToString();
            lblSumEvent.Text = r["Title"].ToString();

            // Set emoji based on event type
            string type = r["EventType"].ToString();
            lblEventEmoji.Text = GetEventEmoji(type);
        }

        // ── Load upcoming shows for this event ────────────────────────────
        private void LoadShows()
        {
            SqlConnection con = new SqlConnection(connStr);
            SqlCommand cmd = new SqlCommand(@"
                SELECT
                    sh.ShowId,
                    sh.ShowDate,
                    sh.StartTime,
                    v.Name     AS VenueName,
                    h.Name     AS HallName,
                    h.HallType,
                    (SELECT MIN(sc.Price) FROM SeatCategories sc WHERE sc.HallId = h.HallId) AS MinPrice,
                    (SELECT COUNT(*) FROM Seats s
                     WHERE s.HallId = sh.HallId
                       AND s.SeatId NOT IN (
                           SELECT bs.SeatId FROM BookedSeats bs
                           WHERE bs.ShowId = sh.ShowId
                             AND bs.Status IN ('Held','Confirmed')
                             AND (bs.HeldUntil IS NULL OR bs.HeldUntil > GETDATE())
                       )
                    ) AS AvailableSeats
                FROM Shows sh
                JOIN Halls  h ON h.HallId  = sh.HallId
                JOIN Venues v ON v.VenueId = h.VenueId
                WHERE sh.EventId = @id
                  AND sh.Status IN ('Upcoming','Live')
                  AND sh.ShowDate >= CAST(GETDATE() AS DATE)
                ORDER BY sh.ShowDate, sh.StartTime", con);

            cmd.Parameters.AddWithValue("@id", eventId);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            if (dt.Rows.Count == 0)
            {
                pnlNoShows.Visible = true;
                rptShows.Visible = false;
            }
            else
            {
                rptShows.DataSource = dt;
                rptShows.DataBind();
            }
        }

        // ── User clicked "Select" on a show ──────────────────────────────
        protected void rptShows_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "SelectShow") return;

            int showId = Convert.ToInt32(e.CommandArgument);
            hfSelectedShowId.Value = showId.ToString();

            // Fill show info in summary
            FillShowSummary(showId);

            // Build seat map
            BuildSeatMap(showId);

            // Show seat map panel, hide show list
            pnlSelectShow.Visible = false;
            pnlSeatMap.Visible = true;
            pnlCoupon.Visible = true;

            SetStepUI(2);
        }

        // ── Fill summary right panel with show info ───────────────────────
        private void FillShowSummary(int showId)
        {
            SqlConnection con = new SqlConnection(connStr);
            SqlCommand cmd = new SqlCommand(@"
                SELECT sh.ShowDate, sh.StartTime, v.Name AS VenueName, h.Name AS HallName
                FROM Shows sh
                JOIN Halls  h ON h.HallId  = sh.HallId
                JOIN Venues v ON v.VenueId = h.VenueId
                WHERE sh.ShowId = @id", con);
            cmd.Parameters.AddWithValue("@id", showId);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            if (dt.Rows.Count == 0) return;
            DataRow r = dt.Rows[0];

            lblSumShow.Text = Convert.ToDateTime(r["ShowDate"]).ToString("dd MMM yyyy") + " at " + r["StartTime"].ToString();
            lblSumVenue.Text = r["VenueName"].ToString() + " - " + r["HallName"].ToString();
        }

        // ── Build the seat map HTML from DB ──────────────────────────────
        private void BuildSeatMap(int showId)
        {
            // Get the hall for this show
            SqlConnection con = new SqlConnection(connStr);
            SqlCommand cmdHall = new SqlCommand("SELECT HallId FROM Shows WHERE ShowId = @id", con);
            cmdHall.Parameters.AddWithValue("@id", showId);
            SqlDataAdapter daHall = new SqlDataAdapter(cmdHall);
            DataTable dtHall = new DataTable();
            daHall.Fill(dtHall);
            if (dtHall.Rows.Count == 0) return;
            int hallId = Convert.ToInt32(dtHall.Rows[0]["HallId"]);

            // Get all seats with their booking status
            SqlCommand cmdSeats = new SqlCommand(@"
                SELECT
                    s.SeatId,
                    s.RowLabel,
                    s.SeatNumber,
                    sc.Name  AS CategoryName,
                    sc.Price
                FROM Seats s
                JOIN SeatCategories sc ON sc.CategoryId = s.CategoryId
                WHERE s.HallId = @hallId
                  AND s.IsActive = 1
                ORDER BY sc.Name, s.RowLabel, s.SeatNumber", con);
            cmdSeats.Parameters.AddWithValue("@hallId", hallId);

            // Get already booked seat IDs for this show
            SqlCommand cmdBooked = new SqlCommand(@"
                SELECT SeatId FROM BookedSeats
                WHERE ShowId = @showId
                  AND Status IN ('Held','Confirmed')
                  AND (HeldUntil IS NULL OR HeldUntil > GETDATE())", con);
            cmdBooked.Parameters.AddWithValue("@showId", showId);

            SqlDataAdapter daSeat = new SqlDataAdapter(cmdSeats);
            DataTable dtSeats = new DataTable();
            daSeat.Fill(dtSeats);

            SqlDataAdapter daBooked = new SqlDataAdapter(cmdBooked);
            DataTable dtBooked = new DataTable();
            daBooked.Fill(dtBooked);

            // Build a set of booked seat IDs for quick lookup
            System.Collections.Generic.HashSet<int> bookedIds = new System.Collections.Generic.HashSet<int>();
            foreach (DataRow br in dtBooked.Rows)
                bookedIds.Add(Convert.ToInt32(br["SeatId"]));

            // Build HTML grouped by Category → Row
            StringBuilder html = new StringBuilder();

            // Group by category first
            string lastCategory = "";
            string lastRow = "";

            foreach (DataRow r in dtSeats.Rows)
            {
                string catName = r["CategoryName"].ToString().Trim();
                string rowLabel = r["RowLabel"].ToString().Trim();
                int seatId = Convert.ToInt32(r["SeatId"]);
                int seatNum = Convert.ToInt32(r["SeatNumber"]);
                decimal price = Convert.ToDecimal(r["Price"]);
                bool isBooked = bookedIds.Contains(seatId);

                // New category section
                if (catName != lastCategory)
                {
                    // Close previous row and section if open
                    if (lastRow != "") html.Append("</div></div>");    // close seats-wrap + seat-row
                    if (lastCategory != "") html.Append("</div>");     // close seat-section

                    html.Append("<div class='seat-section'>");
                    html.Append("<div class='seat-section-label'>" + catName + " — ₹" + price.ToString("N0") + "</div>");

                    lastCategory = catName;
                    lastRow = "";
                }

                // New row
                if (rowLabel != lastRow)
                {
                    if (lastRow != "") html.Append("</div></div>");    // close seats-wrap + seat-row

                    html.Append("<div class='seat-row'>");
                    html.Append("<div class='row-label'>" + rowLabel + "</div>");
                    html.Append("<div class='seats-wrap'>");

                    lastRow = rowLabel;
                }

                // Seat element
                string catClass = catName.ToLower();
                string bookedClass = isBooked ? " booked" : "";
                string label = rowLabel + seatNum;

                if (isBooked)
                {
                    html.Append("<div class='seat " + catClass + bookedClass + "' title='" + label + " — Booked'>" + seatNum + "</div>");
                }
                else
                {
                    html.Append("<div class='seat " + catClass + bookedClass + "' " +
                        "onclick=\"toggleSeat(this," + seatId + ",'" + label + "'," + price + ",'" + catName + "')\" " +
                        "title='" + label + " — ₹" + price + "'>" + seatNum + "</div>");
                }
            }

            // Close any open tags
            if (lastRow != "") html.Append("</div></div>");
            if (lastCategory != "") html.Append("</div>");

            // Add hidden discount field for JS
            html.Append("<input type='hidden' id='hdnDiscount' value='" + hfDiscount.Value + "' />");

            // Add seats summary div for JS to update
            html.Append("<div id='sumSeatsList' style='margin-top:14px;display:flex;flex-wrap:wrap;gap:6px'><span style='color:var(--muted);font-size:13px'>No seats selected yet</span></div>");

            litSeatMap.Text = html.ToString();
        }

        // ── User clicks "Confirm Seats" after selecting on the seat map ───
        protected void btnConfirmSeats_Click(object sender, EventArgs e)
        {
            // Read seat IDs from the posted form value
            string seats = Request.Form["hdnSeats"];

            if (string.IsNullOrEmpty(seats))
            {
                ShowMessage("Please select at least one seat.", false);
                return;
            }

            hfSelectedSeats.Value = seats;

            // Calculate total from DB prices
            CalculateTotals();

            SetStepUI(3);
        }

        // ── Apply coupon ──────────────────────────────────────────────────
        protected void btnApplyCoupon_Click(object sender, EventArgs e)
        {
            string code = txtCoupon.Text.Trim().ToUpper();
            if (string.IsNullOrEmpty(code)) return;

            // Get subtotal to validate min order
            decimal subtotal = GetSubtotal();

            SqlConnection con = new SqlConnection(connStr);
            SqlCommand cmd = new SqlCommand(@"
                SELECT CouponId, DiscountType, DiscountValue, MaxDiscount, MinOrderValue
                FROM Coupons
                WHERE Code = @code
                  AND IsActive = 1
                  AND ValidFrom <= GETDATE()
                  AND ValidTill >= GETDATE()
                  AND (UsageLimit IS NULL OR UsedCount < UsageLimit)", con);
            cmd.Parameters.AddWithValue("@code", code);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            if (dt.Rows.Count == 0)
            {
                lblCouponMsg.Text = "❌ Invalid or expired coupon code.";
                lblCouponMsg.CssClass = "coupon-msg coupon-err";
                lblCouponMsg.Visible = true;
                hfCouponId.Value = "0";
                hfDiscount.Value = "0";
                return;
            }

            DataRow r = dt.Rows[0];
            decimal minOrder = Convert.ToDecimal(r["MinOrderValue"]);

            if (subtotal < minOrder)
            {
                lblCouponMsg.Text = "❌ Minimum order ₹" + minOrder.ToString("N0") + " required for this coupon.";
                lblCouponMsg.CssClass = "coupon-msg coupon-err";
                lblCouponMsg.Visible = true;
                return;
            }

            // Calculate discount
            decimal discount = 0;
            string discType = r["DiscountType"].ToString();
            decimal discVal = Convert.ToDecimal(r["DiscountValue"]);
            object maxDisc = r["MaxDiscount"];

            if (discType == "Percentage")
            {
                discount = subtotal * discVal / 100;
                if (maxDisc != DBNull.Value)
                    discount = Math.Min(discount, Convert.ToDecimal(maxDisc));
            }
            else // Flat
            {
                discount = discVal;
            }

            hfCouponId.Value = r["CouponId"].ToString();
            hfDiscount.Value = discount.ToString("F0");

            lblCouponMsg.Text = "✅ Coupon applied! You save ₹" + discount.ToString("N0");
            lblCouponMsg.CssClass = "coupon-msg coupon-ok";
            lblCouponMsg.Visible = true;

            CalculateTotals();
        }

        // ── Final "Confirm Booking" button ────────────────────────────────
        protected void btnBookNow_Click(object sender, EventArgs e)
        {
            // Re-read seats from form (JS sets hdnSeats on every toggle)
            string seatsCsv = hfSelectedSeats.Value;

            if (string.IsNullOrEmpty(seatsCsv))
            {
                ShowMessage("No seats selected. Please go back and select seats.", false);
                return;
            }

            int showId = Convert.ToInt32(hfSelectedShowId.Value);

            // Get UserId from DB
            int userId = GetUserId();
            if (userId == 0)
            {
                Response.Redirect("Log.aspx");
                return;
            }

            // Calculate amounts
            decimal subtotal = GetSubtotal();
            decimal fee = Math.Round(subtotal * 0.02m);
            decimal discount = Convert.ToDecimal(hfDiscount.Value == "" ? "0" : hfDiscount.Value);
            decimal total = subtotal + fee - discount;

            // Generate unique booking ref
            string bookingRef = "EG" + DateTime.Now.ToString("yyyyMMddHHmmss") + new Random().Next(10, 99);

            int couponId = Convert.ToInt32(hfCouponId.Value == "" ? "0" : hfCouponId.Value);

            // Use the stored procedure sp_CreateBooking
            SqlConnection con = new SqlConnection(connStr);
            con.Open();

            SqlCommand cmd = new SqlCommand("sp_CreateBooking", con);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@UserId", userId);
            cmd.Parameters.AddWithValue("@ShowId", showId);
            cmd.Parameters.AddWithValue("@SeatIds", seatsCsv);
            cmd.Parameters.AddWithValue("@CouponId", couponId == 0 ? (object)DBNull.Value : couponId);
            cmd.Parameters.AddWithValue("@TotalAmount", subtotal);
            cmd.Parameters.AddWithValue("@ConvenienceFee", fee);
            cmd.Parameters.AddWithValue("@DiscountAmount", discount);
            cmd.Parameters.AddWithValue("@FinalAmount", total);
            cmd.Parameters.AddWithValue("@BookingRef", bookingRef);

            SqlParameter outParam = new SqlParameter("@BookingId", System.Data.SqlDbType.Int);
            outParam.Direction = System.Data.ParameterDirection.Output;
            cmd.Parameters.Add(outParam);

            try
            {
                cmd.ExecuteNonQuery();

                int newBookingId = Convert.ToInt32(outParam.Value);

                // Update coupon used count
                if (couponId > 0)
                {
                    SqlCommand updCoupon = new SqlCommand(
                        "UPDATE Coupons SET UsedCount = UsedCount + 1 WHERE CouponId = @id", con);
                    updCoupon.Parameters.AddWithValue("@id", couponId);
                    updCoupon.ExecuteNonQuery();
                }

                con.Close();

                // Redirect to confirmation page
                Response.Redirect("BookingConfirm.aspx?ref=" + bookingRef);
            }
            catch (Exception ex)
            {
                con.Close();
                ShowMessage("Booking failed: " + ex.Message, false);
            }
        }

        // ── Helpers ───────────────────────────────────────────────────────

        private int GetUserId()
        {
            string username = Session["Username"].ToString();
            SqlConnection con = new SqlConnection(connStr);
            SqlCommand cmd = new SqlCommand("SELECT UserId FROM Users WHERE Username = @u", con);
            cmd.Parameters.AddWithValue("@u", username);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            return dt.Rows.Count > 0 ? Convert.ToInt32(dt.Rows[0]["UserId"]) : 0;
        }

        private decimal GetSubtotal()
        {
            string seatsCsv = hfSelectedSeats.Value;
            if (string.IsNullOrEmpty(seatsCsv)) return 0;

            string[] ids = seatsCsv.Split(',');
            if (ids.Length == 0) return 0;

            // Build parameterized IN query
            StringBuilder sqlIn = new StringBuilder();
            SqlConnection con = new SqlConnection(connStr);
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;

            for (int i = 0; i < ids.Length; i++)
            {
                string pName = "@id" + i;
                sqlIn.Append(pName);
                if (i < ids.Length - 1) sqlIn.Append(",");
                cmd.Parameters.AddWithValue(pName, Convert.ToInt32(ids[i].Trim()));
            }

            cmd.CommandText = "SELECT ISNULL(SUM(sc.Price),0) FROM Seats s JOIN SeatCategories sc ON sc.CategoryId = s.CategoryId WHERE s.SeatId IN (" + sqlIn + ")";

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            return dt.Rows.Count > 0 ? Convert.ToDecimal(dt.Rows[0][0]) : 0;
        }

        private void CalculateTotals()
        {
            decimal subtotal = GetSubtotal();
            decimal fee = Math.Round(subtotal * 0.02m);
            decimal discount = Convert.ToDecimal(hfDiscount.Value == "" ? "0" : hfDiscount.Value);
            decimal total = subtotal + fee - discount;

            lblSumSubtotal.Text = subtotal.ToString("N0");
            lblSumFee.Text = fee.ToString("N0");
            lblSumDiscount.Text = discount.ToString("N0");
            lblSumTotal.Text = total.ToString("N0");

            int seatCount = hfSelectedSeats.Value == "" ? 0 : hfSelectedSeats.Value.Split(',').Length;
            lblSumSeats.Text = seatCount > 0 ? seatCount + " seat(s)" : "None selected";
        }

        // ── Update step indicator CSS classes ─────────────────────────────
        private void SetStepUI(int currentStep)
        {
            // Step 1
            string s1 = currentStep == 1 ? "step active" : "step done";
            string s2 = currentStep == 1 ? "step pending" : currentStep == 2 ? "step active" : "step done";
            string s3 = currentStep < 3 ? "step pending" : "step active";
            string l1 = currentStep > 1 ? "step-line done" : "step-line";
            string l2 = currentStep > 2 ? "step-line done" : "step-line";

            step1div.Attributes["class"] = s1;
            step2div.Attributes["class"] = s2;
            step3div.Attributes["class"] = s3;
            line1.Attributes["class"] = l1;
            line2.Attributes["class"] = l2;
        }

        private void ShowMessage(string msg, bool success)
        {
            lblMessage.Text = "<div class='msg-box " + (success ? "msg-success" : "msg-error") + "'>" + msg + "</div>";
            lblMessage.Visible = true;
        }

        private string GetEventEmoji(string eventType)
        {
            switch (eventType)
            {
                case "Movie": return "🎬";
                case "Concert": return "🎵";
                case "Sport": return "⚽";
                case "Play": return "🎭";
                case "Comedy": return "😄";
                default: return "🎪";
            }
        }
    }
}