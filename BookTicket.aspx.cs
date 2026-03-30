using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;

namespace EventGlint
{
    public partial class BookTicket : System.Web.UI.Page
    {
        string connStr = System.Configuration.ConfigurationManager
                              .ConnectionStrings["dbconnection"].ConnectionString;
        int eventId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null) { Response.Redirect("Log.aspx"); return; }
            if (!int.TryParse(Request.QueryString["EventId"], out eventId) || eventId == 0)
            { Response.Redirect("Home.aspx"); return; }

            if (!IsPostBack)
            {
                LoadUserInfo();
                LoadEventDetails();
                LoadShows();
                SetStepUI(1);
            }
        }

        // ── Sidebar user info ─────────────────────────────────────────────
        private void LoadUserInfo()
        {
            string u = Session["Username"].ToString();
            lblUserName.Text = u;
            lblUserRole.Text = "Member";
            lblAvatarInitial.Text = u.Substring(0, 1).ToUpper();
            lblTopAvatar.Text = u.Substring(0, 1).ToUpper();
        }

        // ── Event details ─────────────────────────────────────────────────
        private void LoadEventDetails()
        {
            SqlConnection con = new SqlConnection(connStr);
            SqlCommand cmd = new SqlCommand(
                "SELECT Title, EventType, Language, DurationMins, Description FROM Events WHERE EventId=@id", con);
            cmd.Parameters.AddWithValue("@id", eventId);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            if (dt.Rows.Count == 0) return;

            DataRow r = dt.Rows[0];
            lblEventTitle.Text = r["Title"].ToString();
            lblEventType.Text = r["EventType"].ToString();
            lblLanguage.Text = r["Language"].ToString();
            lblDuration.Text = r["DurationMins"].ToString();
            lblDescription.Text = r["Description"].ToString();
            lblSumEvent.Text = r["Title"].ToString();
            lblEventEmoji.Text = GetEmoji(r["EventType"].ToString());
        }

        // ── Upcoming shows ────────────────────────────────────────────────
        private void LoadShows()
        {
            SqlConnection con = new SqlConnection(connStr);
            SqlCommand cmd = new SqlCommand(@"
                SELECT sh.ShowId, sh.ShowDate, sh.StartTime,
                       v.Name AS VenueName, h.Name AS HallName, h.HallType,
                       (SELECT MIN(sc.Price) FROM SeatCategories sc WHERE sc.HallId=h.HallId) AS MinPrice,
                       (SELECT COUNT(*) FROM Seats s
                        WHERE s.HallId=sh.HallId
                          AND s.SeatId NOT IN (
                              SELECT bs.SeatId FROM BookedSeats bs
                              WHERE bs.ShowId=sh.ShowId
                                AND bs.Status IN ('Held','Confirmed')
                                AND (bs.HeldUntil IS NULL OR bs.HeldUntil > GETDATE())
                          )
                       ) AS AvailableSeats
                FROM Shows sh
                JOIN Halls  h ON h.HallId  = sh.HallId
                JOIN Venues v ON v.VenueId = h.VenueId
                WHERE sh.EventId=@id
                  AND sh.Status IN ('Upcoming','Live')
                  AND sh.ShowDate >= CAST(GETDATE() AS DATE)
                ORDER BY sh.ShowDate, sh.StartTime", con);
            cmd.Parameters.AddWithValue("@id", eventId);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            if (dt.Rows.Count == 0)
            { pnlNoShows.Visible = true; rptShows.Visible = false; }
            else
            { rptShows.DataSource = dt; rptShows.DataBind(); }
        }

        // ── User selects a show → show seat map ──────────────────────────
        protected void rptShows_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "SelectShow") return;

            int showId = Convert.ToInt32(e.CommandArgument);
            hfSelectedShowId.Value = showId.ToString();

            FillShowSummary(showId);
            BuildSeatMap(showId);

            pnlSelectShow.Visible = false;
            pnlSeatMap.Visible = true;
            pnlCoupon.Visible = true;

            SetStepUI(2);
        }

        // ── Fill show info in summary panel ──────────────────────────────
        private void FillShowSummary(int showId)
        {
            SqlConnection con = new SqlConnection(connStr);
            SqlCommand cmd = new SqlCommand(@"
                SELECT sh.ShowDate, sh.StartTime, v.Name AS VenueName, h.Name AS HallName
                FROM Shows sh
                JOIN Halls  h ON h.HallId  = sh.HallId
                JOIN Venues v ON v.VenueId = h.VenueId
                WHERE sh.ShowId=@id", con);
            cmd.Parameters.AddWithValue("@id", showId);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            if (dt.Rows.Count == 0) return;

            DataRow r = dt.Rows[0];
            lblSumShow.Text = Convert.ToDateTime(r["ShowDate"]).ToString("dd MMM yyyy") + " at " + FormatTime(r["StartTime"]);
            lblSumVenue.Text = r["VenueName"] + " — " + r["HallName"];
        }

        // ── Build seat map HTML ───────────────────────────────────────────
        private void BuildSeatMap(int showId)
        {
            SqlConnection con = new SqlConnection(connStr);

            // Get HallId
            SqlCommand cmdH = new SqlCommand("SELECT HallId FROM Shows WHERE ShowId=@id", con);
            cmdH.Parameters.AddWithValue("@id", showId);
            SqlDataAdapter daH = new SqlDataAdapter(cmdH);
            DataTable dtH = new DataTable();
            daH.Fill(dtH);
            if (dtH.Rows.Count == 0) return;
            int hallId = Convert.ToInt32(dtH.Rows[0]["HallId"]);

            // All seats in hall
            SqlCommand cmdS = new SqlCommand(@"
                SELECT s.SeatId, s.RowLabel, s.SeatNumber, sc.Name AS CategoryName, sc.Price
                FROM Seats s
                JOIN SeatCategories sc ON sc.CategoryId=s.CategoryId
                WHERE s.HallId=@hid 
                ORDER BY sc.Name, s.RowLabel, s.SeatNumber", con);
            cmdS.Parameters.AddWithValue("@hid", hallId);

            // Booked / held seats
            SqlCommand cmdB = new SqlCommand(@"
                SELECT SeatId FROM BookedSeats
                WHERE ShowId=@sid AND Status IN ('Held','Confirmed')
                  AND (HeldUntil IS NULL OR HeldUntil > GETDATE())", con);
            cmdB.Parameters.AddWithValue("@sid", showId);

            SqlDataAdapter daS = new SqlDataAdapter(cmdS);
            SqlDataAdapter daB = new SqlDataAdapter(cmdB);
            DataTable dtS = new DataTable();
            DataTable dtB = new DataTable();
            daS.Fill(dtS);
            daB.Fill(dtB);

            var booked = new System.Collections.Generic.HashSet<int>();
            foreach (DataRow br in dtB.Rows)
                booked.Add(Convert.ToInt32(br["SeatId"]));

            StringBuilder html = new StringBuilder();
            string lastCat = "", lastRow = "";

            foreach (DataRow r in dtS.Rows)
            {
                string cat = r["CategoryName"].ToString().Trim();
                string row = r["RowLabel"].ToString().Trim();
                int seatId = Convert.ToInt32(r["SeatId"]);
                int num = Convert.ToInt32(r["SeatNumber"]);
                decimal price = Convert.ToDecimal(r["Price"]);
                bool isBook = booked.Contains(seatId);
                string lbl = row + num;

                if (cat != lastCat)
                {
                    if (lastRow != "") html.Append("</div></div>");
                    if (lastCat != "") html.Append("</div>");
                    html.Append("<div class='seat-section'>");
                    html.Append("<div class='seat-section-label'>" + cat + " — ₹" + price.ToString("N0") + "</div>");
                    lastCat = cat; lastRow = "";
                }

                if (row != lastRow)
                {
                    if (lastRow != "") html.Append("</div></div>");
                    html.Append("<div class='seat-row'>");
                    html.Append("<div class='row-label'>" + row + "</div>");
                    html.Append("<div class='seats-wrap'>");
                    lastRow = row;
                }

                string css = "seat " + cat.ToLower() + (isBook ? " booked" : "");
                if (isBook)
                    html.Append("<div class='" + css + "' title='" + lbl + " — Booked'>" + num + "</div>");
                else
                    html.Append("<div class='" + css + "' onclick=\"toggleSeat(this," + seatId + ",'" + lbl + "'," + price + ",'" + cat + "')\" title='" + lbl + " — ₹" + price + "'>" + num + "</div>");
            }

            if (lastRow != "") html.Append("</div></div>");
            if (lastCat != "") html.Append("</div>");

            html.Append("<input type='hidden' id='hdnDiscount' value='" + hfDiscount.Value + "' />");
            html.Append("<div id='sumSeatsList' style='margin-top:14px;display:flex;flex-wrap:wrap;gap:6px'><span style='color:var(--muted);font-size:13px'>No seats selected yet</span></div>");

            litSeatMap.Text = html.ToString();
        }

        // ── Apply coupon ──────────────────────────────────────────────────
        protected void btnApplyCoupon_Click(object sender, EventArgs e)
        {
            string code = txtCoupon.Text.Trim().ToUpper();
            if (string.IsNullOrEmpty(code)) return;

            decimal subtotal = GetSubtotal(hfSelectedSeats.Value);

            SqlConnection con = new SqlConnection(connStr);
            SqlCommand cmd = new SqlCommand(@"
                SELECT CouponId, DiscountType, DiscountValue, MaxDiscount, MinOrderValue
                FROM Coupons
                WHERE Code=@code AND IsActive=1
                  AND ValidFrom<=GETDATE() AND ValidTill>=GETDATE()
                  AND (UsageLimit IS NULL OR UsedCount < UsageLimit)", con);
            cmd.Parameters.AddWithValue("@code", code);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            if (dt.Rows.Count == 0)
            {
                lblCouponMsg.Text = "❌ Invalid or expired coupon.";
                lblCouponMsg.CssClass = "coupon-msg coupon-err";
                lblCouponMsg.Visible = true;
                hfCouponId.Value = "0"; hfDiscount.Value = "0";
                return;
            }

            DataRow r = dt.Rows[0];
            decimal minOrd = Convert.ToDecimal(r["MinOrderValue"]);
            if (subtotal < minOrd)
            {
                lblCouponMsg.Text = "❌ Minimum order ₹" + minOrd.ToString("N0") + " required.";
                lblCouponMsg.CssClass = "coupon-msg coupon-err";
                lblCouponMsg.Visible = true;
                return;
            }

            decimal discount = 0, discVal = Convert.ToDecimal(r["DiscountValue"]);
            if (r["DiscountType"].ToString() == "Percentage")
            {
                discount = subtotal * discVal / 100;
                if (r["MaxDiscount"] != DBNull.Value)
                    discount = Math.Min(discount, Convert.ToDecimal(r["MaxDiscount"]));
            }
            else discount = discVal;

            hfCouponId.Value = r["CouponId"].ToString();
            hfDiscount.Value = discount.ToString("F0");
            lblCouponMsg.Text = "✅ Coupon applied! You save ₹" + discount.ToString("N0");
            lblCouponMsg.CssClass = "coupon-msg coupon-ok";
            lblCouponMsg.Visible = true;
        }

        // ── Confirm Seats → create booking (Pending) → go to Payment ─────
        protected void btnConfirmSeats_Click(object sender, EventArgs e)
        {
            // Read seats from the JS-populated hidden field
            string seatsCsv = Request.Form["hdnSeats"];

            if (string.IsNullOrEmpty(seatsCsv))
            {
                ShowMessage("Please select at least one seat first.", false);
                return;
            }

            hfSelectedSeats.Value = seatsCsv;

            int showId = Convert.ToInt32(hfSelectedShowId.Value);
            int userId = GetUserId();
            if (userId == 0) { Response.Redirect("Log.aspx"); return; }

            // Amounts
            decimal subtotal = GetSubtotal(seatsCsv);
            decimal fee = Math.Round(subtotal * 0.02m);
            decimal discount = string.IsNullOrEmpty(hfDiscount.Value) ? 0 : Convert.ToDecimal(hfDiscount.Value);
            decimal total = subtotal + fee - discount;
            int couponId = string.IsNullOrEmpty(hfCouponId.Value) ? 0 : Convert.ToInt32(hfCouponId.Value);
            string bookingRef = "EG" + DateTime.Now.ToString("yyyyMMddHHmmss") + new Random().Next(10, 99);

            int bookingId = 0;
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
                    SqlTransaction tx = con.BeginTransaction();
                    try
                    {
                        // 1. Insert Booking with Status = 'Pending'
                        SqlCommand cmdBook = new SqlCommand(@"
                            INSERT INTO Bookings
                                (UserId, ShowId, TotalAmount, ConvenienceFee, DiscountAmount,
                                 FinalAmount, CouponId, BookingRef, Status, BookingDate)
                            VALUES
                                (@uid, @sid, @tot, @fee, @disc,
                                 @fin, @cid, @ref, 'Pending', GETDATE());
                            SELECT SCOPE_IDENTITY();", con, tx);

                        cmdBook.Parameters.AddWithValue("@uid", userId);
                        cmdBook.Parameters.AddWithValue("@sid", showId);
                        cmdBook.Parameters.AddWithValue("@tot", subtotal);
                        cmdBook.Parameters.AddWithValue("@fee", fee);
                        cmdBook.Parameters.AddWithValue("@disc", discount);
                        cmdBook.Parameters.AddWithValue("@fin", total);
                        cmdBook.Parameters.AddWithValue("@cid", couponId > 0 ? (object)couponId : DBNull.Value);
                        cmdBook.Parameters.AddWithValue("@ref", bookingRef);
                        bookingId = Convert.ToInt32(cmdBook.ExecuteScalar());

                        // 2. Hold each seat for 10 minutes
                        foreach (string sid in seatsCsv.Split(','))
                        {
                            if (!int.TryParse(sid.Trim(), out int seatId)) continue;

                            SqlCommand cmdPrice = new SqlCommand(
                                "SELECT sc.Price FROM Seats s JOIN SeatCategories sc ON sc.CategoryId=s.CategoryId WHERE s.SeatId=@id",
                                con, tx);
                            cmdPrice.Parameters.AddWithValue("@id", seatId);
                            decimal seatPrice = Convert.ToDecimal(cmdPrice.ExecuteScalar());

                            SqlCommand cmdSeat = new SqlCommand(@"
                                INSERT INTO BookedSeats (BookingId,SeatId,ShowId,PricePaid,Status,HeldUntil)
                                VALUES (@bid,@seatId,@showId,@price,'Held',DATEADD(MINUTE,10,GETDATE()))",
                                con, tx);
                            cmdSeat.Parameters.AddWithValue("@bid", bookingId);
                            cmdSeat.Parameters.AddWithValue("@seatId", seatId);
                            cmdSeat.Parameters.AddWithValue("@showId", showId);
                            cmdSeat.Parameters.AddWithValue("@price", seatPrice);
                            cmdSeat.ExecuteNonQuery();
                        }

                        // 3. Mark coupon as used
                        if (couponId > 0)
                        {
                            SqlCommand cmdCoupon = new SqlCommand(
                                "UPDATE Coupons SET UsedCount=UsedCount+1 WHERE CouponId=@id", con, tx);
                            cmdCoupon.Parameters.AddWithValue("@id", couponId);
                            cmdCoupon.ExecuteNonQuery();
                        }

                        tx.Commit();
                    }
                    catch { tx.Rollback(); throw; }
                }

                // Save to session for Payment page
                Session["BookingId"] = bookingId;
                Session["BookingRef"] = bookingRef;

                // ── Go to Payment page ──────────────────────────────
                Response.Redirect("Payment.aspx?BookingId=" + bookingId + "&ref=" + bookingRef);
            }
            catch (Exception ex)
            {
                ShowMessage("Booking failed: " + ex.Message, false);
            }
        }

        // ── Helpers ───────────────────────────────────────────────────────
        private int GetUserId()
        {
            string u = Session["Username"].ToString();
            SqlConnection con = new SqlConnection(connStr);
            SqlCommand cmd = new SqlCommand("SELECT UserId FROM Users WHERE Username=@u", con);
            cmd.Parameters.AddWithValue("@u", u);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            return dt.Rows.Count > 0 ? Convert.ToInt32(dt.Rows[0]["UserId"]) : 0;
        }

        private decimal GetSubtotal(string seatsCsv)
        {
            if (string.IsNullOrEmpty(seatsCsv)) return 0;
            string[] ids = seatsCsv.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            if (ids.Length == 0) return 0;

            StringBuilder sqlIn = new StringBuilder();
            SqlConnection con = new SqlConnection(connStr);
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            for (int i = 0; i < ids.Length; i++)
            {
                string p = "@p" + i;
                if (i > 0) sqlIn.Append(",");
                sqlIn.Append(p);
                cmd.Parameters.AddWithValue(p, Convert.ToInt32(ids[i].Trim()));
            }
            cmd.CommandText = "SELECT ISNULL(SUM(sc.Price),0) FROM Seats s JOIN SeatCategories sc ON sc.CategoryId=s.CategoryId WHERE s.SeatId IN (" + sqlIn + ")";

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            return dt.Rows.Count > 0 ? Convert.ToDecimal(dt.Rows[0][0]) : 0;
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
            lblMessage.Text = "<div class='msg-box " + (success ? "msg-success" : "msg-error") + "'>" + msg + "</div>";
            lblMessage.Visible = true;
        }

        private string FormatTime(object val)
        {
            if (val == null || val == DBNull.Value) return "";
            if (val is TimeSpan ts) return DateTime.Today.Add(ts).ToString("hh:mm tt");
            if (TimeSpan.TryParse(val.ToString(), out TimeSpan p)) return DateTime.Today.Add(p).ToString("hh:mm tt");
            return val.ToString();
        }

        private string GetEmoji(string type)
        {
            switch (type)
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