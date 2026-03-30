using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EventGlint
{
    public partial class BookHall : System.Web.UI.Page
    {
        private string connStr = System.Configuration.ConfigurationManager
                                      .ConnectionStrings["dbconnection"].ConnectionString;
        private int hallId = 0;

        // ── Price map keyed by HallId — matches prices on your Hall.aspx cards.
        // No extra DB table needed. Update values here if prices change.
        private static readonly System.Collections.Generic.Dictionary<int, decimal> PriceMap =
     new System.Collections.Generic.Dictionary<int, decimal>
     {
        { 11983, 85000m },   // Grand Ballroom
        { 11984, 45000m },   // Royal Crystal
        { 11985, 38000m },   // Garden Wedding Pavilion
        { 11986, 65000m },   // Luxury Crystal Dome
     };

        // ─────────────────────────────────────────────────────────────────
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null) { Response.Redirect("Log.aspx"); return; }

            if (!int.TryParse(Request.QueryString["HallId"], out hallId) || hallId == 0)
            { Response.Redirect("Hall.aspx"); return; }

            hfHallId.Value = hallId.ToString();

            LoadUserInfo();
            LoadHallDetails();   // runs every request — keeps summary labels alive on postbacks

            if (!IsPostBack)
            {
                txtBookingDate.Text = DateTime.Today.AddDays(1).ToString("yyyy-MM-dd");
                btnBookNow.Enabled = false;
                SetStepUI(1);
            }
            else
            {
                bool avail = hfIsAvailable.Value == "1";
                btnBookNow.Enabled = avail;

                if (avail)
                {
                    RefreshSummaryLabels();
                    pnlCoupon.Visible = true;
                    pnlPriceBreakdown.Visible = true;
                    pnlAvailability.Visible = true;
                    SetStepUI(3);
                }
                else
                {
                    SetStepUI(2);
                }
            }
        }

        // ─────────────────────────────────────────────────────────────────
        private void LoadUserInfo()
        {
            string u = Session["Username"].ToString();
            lblUserName.Text = u;
            lblUserRole.Text = "Member";
            lblAvatarInitial.Text = u.Substring(0, 1).ToUpper();
            lblTopAvatar.Text = u.Substring(0, 1).ToUpper();
        }

        // ─────────────────────────────────────────────────────────────────
        // Uses only: Halls + Venues (both already in your DB)
        // ─────────────────────────────────────────────────────────────────
        //private void LoadHallDetails()
        //{
        //    int id = int.Parse(hfHallId.Value);

        //    using (SqlConnection con = new SqlConnection(connStr))
        //    {
        //        SqlCommand cmd = new SqlCommand(@"
        //            SELECT
        //                h.Name          AS HallName,
        //                h.HallType,
        //                h.TotalCapacity,
        //                v.Name          AS VenueName,
        //                v.Address       AS VenueAddress
        //            FROM  Halls  h
        //            JOIN  Venues v ON v.VenueId = h.VenueId
        //            WHERE h.HallId = @id", con);

        //        cmd.Parameters.AddWithValue("@id", id);
        //        SqlDataAdapter da = new SqlDataAdapter(cmd);
        //        DataTable dt = new DataTable();
        //        da.Fill(dt);
        //        if (dt.Rows.Count == 0) { Response.Redirect("Hall.aspx"); return; }

        //        DataRow r = dt.Rows[0];

        //        lblHallName.Text = r["HallName"].ToString();
        //        lblHallType.Text = r["HallType"].ToString();
        //        lblCapacity.Text = r["TotalCapacity"].ToString() + " guests";
        //        lblVenueName.Text = r["VenueName"].ToString();
        //        txtVenueAddress.Text = r["VenueName"].ToString();
        //        lblHallDesc.Text = GetHallDescription(r["HallType"].ToString());

        //        lblSumHall.Text = r["HallName"].ToString();
        //        lblSumVenue.Text = r["VenueName"].ToString();

        //        // Price from in-memory map — zero extra DB tables required
        //        decimal price = PriceMap.ContainsKey(id) ? PriceMap[id] : 50000m;
        //        ViewState["PricePerDay"] = price;
        //        ViewState["Capacity"] = Convert.ToInt32(r["TotalCapacity"]);
        //    }
        //}
        private void LoadHallDetails()
        {
            int id = int.Parse(hfHallId.Value);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
            SELECT
                h.Name          AS HallName,
                h.HallType,
                h.TotalCapacity,
                v.Name          AS VenueName,
                v.Address       AS VenueAddress
            FROM  Halls  h
            JOIN  Venues v ON v.VenueId = h.VenueId
            WHERE h.HallId = @id", con);

                cmd.Parameters.AddWithValue("@id", id);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                if (dt.Rows.Count == 0) { Response.Redirect("Hall.aspx"); return; }

                DataRow r = dt.Rows[0];

                lblHallName.Text = r["HallName"].ToString();
                lblHallType.Text = r["HallType"].ToString();
                lblCapacity.Text = r["TotalCapacity"].ToString() + " guests";
                lblVenueName.Text = r["VenueName"].ToString();
                txtVenueAddress.Text = r["VenueAddress"].ToString();
                lblHallDesc.Text = GetHallDescription(r["HallType"].ToString());

                lblSumHall.Text = r["HallName"].ToString();
                lblSumVenue.Text = r["VenueName"].ToString();

                decimal price = PriceMap.ContainsKey(id) ? PriceMap[id] : 50000m;
                ViewState["PricePerDay"] = price;
                ViewState["Capacity"] = Convert.ToInt32(r["TotalCapacity"]);
            }
        }
        // ─────────────────────────────────────────────────────────────────
        // "Check Availability" — queries Shows + Bookings (existing tables)
        // ─────────────────────────────────────────────────────────────────
        protected void btnCheckAvailability_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtBookingDate.Text))
            { ShowMessage("Please select a booking date.", false); return; }

            if (!DateTime.TryParse(txtBookingDate.Text, out DateTime bookingDate))
            { ShowMessage("Invalid date.", false); return; }

            if (bookingDate.Date < DateTime.Today)
            { ShowMessage("Booking date cannot be in the past.", false); return; }

            if (string.IsNullOrEmpty(ddlPurpose.SelectedValue))
            { ShowMessage("Please select the purpose of your event.", false); return; }

            if (!int.TryParse(txtGuests.Text, out int guests) || guests <= 0)
            { ShowMessage("Please enter a valid guest count.", false); return; }

            int id = int.Parse(hfHallId.Value);
            int days = int.Parse(ddlDays.SelectedValue);
            int capacity = ViewState["Capacity"] != null ? (int)ViewState["Capacity"] : 0;

            if (capacity > 0 && guests > capacity)
            {
                ShowMessage($"⚠️ This hall holds a maximum of {capacity} guests.", false);
                return;
            }

            bool available = IsHallAvailable(id, bookingDate, days);

            pnlAvailability.Visible = true;

            if (available)
            {
                decimal pricePerDay = (decimal)ViewState["PricePerDay"];
                decimal subtotal = pricePerDay * days;
                decimal fee = Math.Round(subtotal * 0.02m);
                decimal discount = decimal.TryParse(hfDiscount.Value, out decimal disc) ? disc : 0m;
                decimal total = subtotal + fee - discount;

                lblAvailability.Text =
                    $"<div class='avail-banner avail-ok'>✅ Hall is available on " +
                    $"{bookingDate:dd MMM yyyy} for {days} day(s)! Proceed to confirm.</div>";

                lblPricePerDay.Text = pricePerDay.ToString("N0");
                lblDaysCalc.Text = days.ToString();
                lblSubtotalCalc.Text = subtotal.ToString("N0");
                lblFeeCalc.Text = fee.ToString("N0");
                lblTotalCalc.Text = (subtotal + fee).ToString("N0");
                pnlPriceBreakdown.Visible = true;

                lblSumDate.Text = bookingDate.ToString("dd MMM yyyy");
                lblSumDays.Text = days + (days == 1 ? " day" : " days");
                lblSumPurpose.Text = ddlPurpose.SelectedItem.Text;
                lblSumSubtotal.Text = subtotal.ToString("N0");
                lblSumFee.Text = fee.ToString("N0");
                lblSumDiscount.Text = discount.ToString("N0");
                lblSumTotal.Text = total.ToString("N0");

                hfIsAvailable.Value = "1";
                btnBookNow.Enabled = true;
                pnlCoupon.Visible = true;

                ViewState["BookingDate"] = bookingDate;
                ViewState["Days"] = days;
                ViewState["Guests"] = guests;

                SetStepUI(3);
            }
            else
            {
                lblAvailability.Text =
                    $"<div class='avail-banner avail-no'>❌ This hall is already booked on " +
                    $"{bookingDate:dd MMM yyyy}. Please choose a different date.</div>";

                hfIsAvailable.Value = "0";
                btnBookNow.Enabled = false;
                pnlPriceBreakdown.Visible = false;
                pnlCoupon.Visible = false;
                SetStepUI(2);
            }
        }

        // ─────────────────────────────────────────────────────────────────
        // Apply coupon — existing Coupons table, unchanged
        // ─────────────────────────────────────────────────────────────────
        protected void btnApplyCoupon_Click(object sender, EventArgs e)
        {
            string code = txtCoupon.Text.Trim().ToUpper();
            if (string.IsNullOrEmpty(code)) return;

            decimal pricePerDay = (decimal)ViewState["PricePerDay"];
            int days = ViewState["Days"] != null ? (int)ViewState["Days"] : 1;
            decimal subtotal = pricePerDay * days;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
                    SELECT CouponId, DiscountType, DiscountValue, MaxDiscount, MinOrderValue
                    FROM   Coupons
                    WHERE  Code      = @code
                      AND  IsActive  = 1
                      AND  ValidFrom <= GETDATE()
                      AND  ValidTill >= GETDATE()
                      AND  (UsageLimit IS NULL OR UsedCount < UsageLimit)", con);
                cmd.Parameters.AddWithValue("@code", code);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count == 0)
                {
                    lblCouponMsg.Text = "❌ Invalid or expired coupon code.";
                    lblCouponMsg.CssClass = "coupon-msg coupon-err";
                    lblCouponMsg.Visible = true;
                    hfCouponId.Value = "0"; hfDiscount.Value = "0";
                    RefreshSummaryLabels();
                    return;
                }

                DataRow r = dt.Rows[0];
                decimal minOrd = Convert.ToDecimal(r["MinOrderValue"]);
                if (subtotal < minOrd)
                {
                    lblCouponMsg.Text = $"❌ Minimum order ₹{minOrd:N0} required.";
                    lblCouponMsg.CssClass = "coupon-msg coupon-err";
                    lblCouponMsg.Visible = true;
                    return;
                }

                decimal discount = 0;
                string discType = r["DiscountType"].ToString();
                decimal discVal = Convert.ToDecimal(r["DiscountValue"]);
                object maxDisc = r["MaxDiscount"];

                if (discType == "Percentage")
                {
                    discount = subtotal * discVal / 100m;
                    if (maxDisc != DBNull.Value)
                        discount = Math.Min(discount, Convert.ToDecimal(maxDisc));
                }
                else
                {
                    discount = discVal;
                }

                hfCouponId.Value = r["CouponId"].ToString();
                hfDiscount.Value = discount.ToString("F0");

                lblCouponMsg.Text = $"✅ Coupon applied! You save ₹{discount:N0}";
                lblCouponMsg.CssClass = "coupon-msg coupon-ok";
                lblCouponMsg.Visible = true;
            }

            RefreshSummaryLabels();
        }

        // ─────────────────────────────────────────────────────────────────
        // "Confirm Hall Booking"
        //
        // Uses ONLY existing tables — no new tables created:
        //   1. GetOrCreateHallRentalEvent() → ensures one reusable "Hall Rental"
        //      row exists in Events (inserts it once, then reuses forever).
        //   2. INSERT into Shows  → represents the booked date/hall.
        //   3. INSERT into Bookings → the actual booking record.
        //   4. Purpose + guest info stored in Session for confirmation page.
        // ─────────────────────────────────────────────────────────────────
        protected void btnBookNow_Click(object sender, EventArgs e)
        {
            if (hfIsAvailable.Value != "1")
            { ShowMessage("Please check availability first.", false); return; }

            int userId = GetUserId();
            if (userId == 0) { Response.Redirect("Log.aspx"); return; }

            int id = int.Parse(hfHallId.Value);
            DateTime bookingDate = ViewState["BookingDate"] != null
                                    ? (DateTime)ViewState["BookingDate"]
                                    : DateTime.Parse(txtBookingDate.Text);
            int days = ViewState["Days"] != null ? (int)ViewState["Days"] : int.Parse(ddlDays.SelectedValue);
            int guests = ViewState["Guests"] != null ? (int)ViewState["Guests"] : (int.TryParse(txtGuests.Text, out int gv) ? gv : 0);
            string startTime = ddlStartTime.SelectedValue + ":00";  // e.g. "14:00:00"
            string purpose = ddlPurpose.SelectedValue;
            string purposeText = ddlPurpose.SelectedItem.Text;
            string requirements = txtRequirements.Text.Trim();

            decimal pricePerDay = (decimal)ViewState["PricePerDay"];
            decimal subtotal = pricePerDay * days;
            decimal fee = Math.Round(subtotal * 0.02m);
            decimal discount = decimal.TryParse(hfDiscount.Value, out decimal d) ? d : 0m;
            decimal total = subtotal + fee - discount;
            int couponId = int.TryParse(hfCouponId.Value, out int c) ? c : 0;

            string bookingRef = "HB" + DateTime.Now.ToString("yyyyMMddHHmmss") + new Random().Next(10, 99);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlTransaction tx = con.BeginTransaction();
                try
                {
                    // 1. Get or create the single "Hall Rental" placeholder event
                    int eventId = GetOrCreateHallRentalEvent(con, tx);

                    // 2. Insert a Show row for this hall + date
                    SqlCommand cmdShow = new SqlCommand(@"
                        INSERT INTO Shows (EventId, HallId, ShowDate, StartTime, Status)
                        VALUES (@eventId, @hallId, @showDate, @startTime, 'Upcoming');
                        SELECT SCOPE_IDENTITY();", con, tx);

                    cmdShow.Parameters.AddWithValue("@eventId", eventId);
                    cmdShow.Parameters.AddWithValue("@hallId", id);
                    cmdShow.Parameters.AddWithValue("@showDate", bookingDate.Date);
                    cmdShow.Parameters.AddWithValue("@startTime", startTime);

                    int showId = Convert.ToInt32(cmdShow.ExecuteScalar());

                    // 3. Insert into Bookings
                    SqlCommand cmdBooking = new SqlCommand(@"
                        INSERT INTO Bookings
                            (UserId, ShowId, TotalAmount, DiscountAmount, FinalAmount,
                             CouponId, BookingRef, Status, BookingDate)
                        VALUES
                            (@userId, @showId, @totalAmount, @discountAmount, @finalAmount,
                             @couponId, @bookingRef, 'Confirmed', GETDATE());
                        SELECT SCOPE_IDENTITY();", con, tx);

                    cmdBooking.Parameters.AddWithValue("@userId", userId);
                    cmdBooking.Parameters.AddWithValue("@showId", showId);
                    cmdBooking.Parameters.AddWithValue("@totalAmount", subtotal);
                    cmdBooking.Parameters.AddWithValue("@discountAmount", discount);
                    cmdBooking.Parameters.AddWithValue("@finalAmount", total);
                    cmdBooking.Parameters.AddWithValue("@couponId", couponId > 0 ? (object)couponId : DBNull.Value);
                    cmdBooking.Parameters.AddWithValue("@bookingRef", bookingRef);

                    int bookingId = Convert.ToInt32(cmdBooking.ExecuteScalar());

                    // 4. Increment coupon usage
                    if (couponId > 0)
                    {
                        SqlCommand cmdCoupon = new SqlCommand(
                            "UPDATE Coupons SET UsedCount = UsedCount + 1 WHERE CouponId = @id",
                            con, tx);
                        cmdCoupon.Parameters.AddWithValue("@id", couponId);
                        cmdCoupon.ExecuteNonQuery();
                    }

                    tx.Commit();

                    // Pass extra hall-specific info to confirmation page via Session
                    Session["HallBookingRef"] = bookingRef;
                    Session["HallBookingId"] = bookingId;
                    Session["HallShowId"] = showId;
                    Session["HallPurpose"] = purposeText;
                    Session["HallDays"] = days;
                    Session["HallGuests"] = guests;
                    Session["HallStartTime"] = ddlStartTime.SelectedItem.Text;  // "02:00 PM"
                    Session["HallFinalAmount"] = total;
                    Session["HallRequirements"] = requirements;

                    Response.Redirect("HallPayment.aspx");

                }
                catch (Exception ex)
                {
                    ShowMessage("Booking failed: " + ex.Message, false);
                }
            }
        }

        // ─────────────────────────────────────────────────────────────────
        // Finds or auto-creates one reusable "Hall Rental" row in Events.
        // This runs inside the same transaction.
        // ─────────────────────────────────────────────────────────────────
        private int GetOrCreateHallRentalEvent(SqlConnection con, SqlTransaction tx)
        {
            SqlCommand cmdFind = new SqlCommand(
                "SELECT TOP 1 EventId FROM Events WHERE Title = 'Hall Rental'",
                con, tx);
            object found = cmdFind.ExecuteScalar();
            if (found != null && found != DBNull.Value)
                return Convert.ToInt32(found);

            SqlCommand cmdIns = new SqlCommand(@"
        INSERT INTO Events (Title, EventType, Language, DurationMins, Description)
        VALUES ('Hall Rental', 'Other', 'N/A', 0,
                'System placeholder for hall rental bookings.');
        SELECT SCOPE_IDENTITY();", con, tx);

            return Convert.ToInt32(cmdIns.ExecuteScalar());
        }

        // ─────────────────────────────────────────────────────────────────
        // Availability check — uses Shows + Bookings (existing tables)
        // ─────────────────────────────────────────────────────────────────
        private bool IsHallAvailable(int id, DateTime startDate, int days)
        {
            DateTime endDate = startDate.AddDays(days - 1);
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
                    SELECT COUNT(*)
                    FROM   Shows    sh
                    JOIN   Bookings b  ON b.ShowId = sh.ShowId
                    WHERE  sh.HallId    = @hallId
                      AND  sh.ShowDate >= @startDate
                      AND  sh.ShowDate <= @endDate
                      AND  b.Status    = 'Confirmed'", con);

                cmd.Parameters.AddWithValue("@hallId", id);
                cmd.Parameters.AddWithValue("@startDate", startDate.Date);
                cmd.Parameters.AddWithValue("@endDate", endDate.Date);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return Convert.ToInt32(dt.Rows[0][0]) == 0;
            }
        }

        // ─────────────────────────────────────────────────────────────────
        private int GetUserId()
        {
            string username = Session["Username"].ToString();
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT UserId FROM Users WHERE Username = @u", con);
                cmd.Parameters.AddWithValue("@u", username);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt.Rows.Count > 0 ? Convert.ToInt32(dt.Rows[0]["UserId"]) : 0;
            }
        }

        private void RefreshSummaryLabels()
        {
            decimal pricePerDay = ViewState["PricePerDay"] != null ? (decimal)ViewState["PricePerDay"] : 0m;
            int days = ViewState["Days"] != null ? (int)ViewState["Days"] : 1;
            decimal subtotal = pricePerDay * days;
            decimal fee = Math.Round(subtotal * 0.02m);
            decimal discount = decimal.TryParse(hfDiscount.Value, out decimal d) ? d : 0m;
            decimal total = subtotal + fee - discount;

            lblSumSubtotal.Text = subtotal.ToString("N0");
            lblSumFee.Text = fee.ToString("N0");
            lblSumDiscount.Text = discount.ToString("N0");
            lblSumTotal.Text = total.ToString("N0");

            lblPricePerDay.Text = pricePerDay.ToString("N0");
            lblDaysCalc.Text = days.ToString();
            lblSubtotalCalc.Text = subtotal.ToString("N0");
            lblFeeCalc.Text = fee.ToString("N0");
            lblTotalCalc.Text = (subtotal + fee).ToString("N0");
        }

        private void SetStepUI(int step)
        {
            step1div.Attributes["class"] = step == 1 ? "step active" : "step done";
            step2div.Attributes["class"] = step == 1 ? "step pending" : step == 2 ? "step active" : "step done";
            step3div.Attributes["class"] = step < 3 ? "step pending" : "step active";
            line1.Attributes["class"] = step > 1 ? "step-line done" : "step-line";
            line2.Attributes["class"] = step > 2 ? "step-line done" : "step-line";
        }

        private void ShowMessage(string msg, bool success)
        {
            lblMessage.Text = $"<div class='msg-box {(success ? "msg-success" : "msg-error")}'>{msg}</div>";
            lblMessage.Visible = true;
        }

        private string GetHallDescription(string hallType)
        {
            switch (hallType)
            {
                case "IMAX": return "Premium IMAX hall with the largest screen and immersive audio.";
                case "4DX": return "State-of-the-art 4DX hall with motion seats and special effects.";
                case "Dolby": return "Dolby Atmos certified hall with crystal-clear surround sound.";
                case "3D": return "Modern 3D hall equipped with the latest projection technology.";
                default: return "Well-equipped hall perfect for weddings, corporate events and celebrations.";
            }
        }
    }
}