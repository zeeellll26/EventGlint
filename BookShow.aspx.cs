using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace EventGlint
{
    public partial class BookShow : System.Web.UI.Page
    {
        private string connStr = System.Configuration.ConfigurationManager
                                      .ConnectionStrings["dbconnection"].ConnectionString;
        private int showId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null) { Response.Redirect("Log.aspx"); return; }
            if (!int.TryParse(Request.QueryString["ShowId"], out showId) || showId == 0)
            { Response.Redirect("Shows.aspx"); return; }

            hfShowId.Value = showId.ToString();
            LoadUserInfo();
            LoadShowDetails();
            BuildSeatGrid();
            RefreshSummary();

            //if (!IsPostBack)
            //{
            //    btnProceed.Enabled = true;
            //}
        }

        private void LoadUserInfo()
        {
            string u = Session["Username"].ToString();
            lblUserName.Text = u;
            lblUserRole.Text = "Member";
            lblAvatarInitial.Text = u.Substring(0, 1).ToUpper();
            lblTopAvatar.Text = u.Substring(0, 1).ToUpper();
        }

        private void LoadShowDetails()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
                    SELECT e.Title, e.EventType, e.Language, e.DurationMins,
                           s.ShowDate, s.StartTime,
                           h.Name AS HallName, v.Name AS VenueName
                    FROM   Shows   s
                    JOIN   Events  e ON e.EventId = s.EventId
                    JOIN   Halls   h ON h.HallId  = s.HallId
                    JOIN   Venues  v ON v.VenueId = h.VenueId
                    WHERE  s.ShowId = @id", con);
                cmd.Parameters.AddWithValue("@id", showId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                if (dt.Rows.Count == 0) { Response.Redirect("Shows.aspx"); return; }

                DataRow r = dt.Rows[0];
                lblEventTitle.Text = r["Title"].ToString();
                lblEventType.Text = r["EventType"].ToString();
                lblLanguage.Text = r["Language"] != DBNull.Value ? r["Language"].ToString() : "—";
                lblDuration.Text = r["DurationMins"] != DBNull.Value ? r["DurationMins"].ToString() + " mins" : "—";
                lblShowDate.Text = Convert.ToDateTime(r["ShowDate"]).ToString("dd MMM yyyy");
                lblShowTime.Text = FormatTime(r["StartTime"]);
                lblHallName.Text = r["HallName"].ToString();

                lblSumShow.Text = r["Title"].ToString();
                lblSumDateTime.Text = Convert.ToDateTime(r["ShowDate"]).ToString("dd MMM yyyy") + " " + FormatTime(r["StartTime"]);

                ViewState["HallName"] = r["HallName"].ToString();
                ViewState["ShowTitle"] = r["Title"].ToString();
                ViewState["ShowDate"] = lblShowDate.Text;
                ViewState["ShowTime"] = lblShowTime.Text;
            }
        }

        private void BuildSeatGrid()
        {
            int id = int.Parse(hfShowId.Value);
            string selectedSeats = hfSelected.Value;
            var selectedList = new HashSet<string>(selectedSeats.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries));

            // Get booked seat IDs for this show
            var bookedSeatIds = new HashSet<int>();
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
                    SELECT bs.SeatId FROM BookedSeats bs
                    JOIN   Bookings  b  ON b.BookingId = bs.BookingId
                    WHERE  bs.ShowId = @showId
                      AND  bs.Status IN ('Held','Confirmed')
                      AND  b.Status  IN ('Pending','Confirmed')", con);
                cmd.Parameters.AddWithValue("@showId", id);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                foreach (DataRow r in dt.Rows)
                    bookedSeatIds.Add(Convert.ToInt32(r["SeatId"]));
            }

            // Get seats for this show's hall with category info
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
                    SELECT s.SeatId, s.RowLabel, s.SeatNumber, s.IsWheelchair,
                           sc.Name AS CategoryName, sc.Price
                    FROM   Seats          s
                    JOIN   SeatCategories sc ON sc.CategoryId = s.CategoryId
                    JOIN   Shows          sh ON sh.HallId     = s.HallId
                    WHERE  sh.ShowId = @showId
                    ORDER  BY sc.Name, s.RowLabel, s.SeatNumber", con);
                cmd.Parameters.AddWithValue("@showId", id);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count == 0)
                {
                    var noSeats = new HtmlGenericControl("div");
                    noSeats.InnerText = "No seats configured for this show.";
                    noSeats.Style["color"] = "var(--muted)";
                    noSeats.Style["font-size"] = "14px";
                    phSeats.Controls.Add(noSeats);
                    return;
                }

                // Store prices in ViewState
                var priceMap = new Dictionary<int, decimal>();
                string currentCat = null;
                string currentRow = null;
                HtmlGenericControl catDiv = null;
                HtmlGenericControl rowDiv = null;

                foreach (DataRow r in dt.Rows)
                {
                    int seatId = Convert.ToInt32(r["SeatId"]);
                    string rowLbl = r["RowLabel"].ToString().Trim();
                    int seatNum = Convert.ToInt32(r["SeatNumber"]);
                    string cat = r["CategoryName"].ToString();
                    decimal price = Convert.ToDecimal(r["Price"]);
                    bool isBooked = bookedSeatIds.Contains(seatId);
                    bool isSelected = selectedList.Contains(seatId.ToString());

                    priceMap[seatId] = price;

                    if (cat != currentCat)
                    {
                        catDiv = new HtmlGenericControl("div");
                        catDiv.Attributes["class"] = "seat-category";
                        var catLabel = new HtmlGenericControl("div");
                        catLabel.Attributes["class"] = "cat-label";
                        catLabel.InnerText = cat + " — ₹" + price.ToString("N0");
                        catDiv.Controls.Add(catLabel);
                        phSeats.Controls.Add(catDiv);
                        currentCat = cat;
                        currentRow = null;
                    }

                    if (rowLbl != currentRow)
                    {
                        rowDiv = new HtmlGenericControl("div");
                        rowDiv.Attributes["class"] = "seat-row";
                        var rowLabel = new HtmlGenericControl("span");
                        rowLabel.Attributes["class"] = "row-label";
                        rowLabel.InnerText = rowLbl;
                        rowDiv.Controls.Add(rowLabel);
                        catDiv.Controls.Add(rowDiv);
                        currentRow = rowLbl;
                    }

                    var seat = new HtmlGenericControl("div");
                    string cssClass = "seat" + (isBooked ? " booked" : "") + (isSelected ? " selected" : "");
                    seat.Attributes["class"] = cssClass;
                    seat.InnerText = seatNum.ToString();
                    if (!isBooked)
                        seat.Attributes["onclick"] = $"toggleSeat(this,{seatId},{price})";
                    seat.Attributes["title"] = $"{rowLbl}{seatNum} — ₹{price:N0}";
                    rowDiv.Controls.Add(seat);
                }

                ViewState["PriceMap"] = priceMap;
            }
        }

        private void RefreshSummary()
        {
            string selectedSeats = hfSelected.Value;
            var selectedIds = selectedSeats.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

            if (selectedIds.Length == 0)
            {
                lblSumSeats.Text = "—";
                lblSumSubtotal.Text = "0";
                lblSumFee.Text = "0";
                lblSumDiscount.Text = "0";
                lblSumTotal.Text = "0";
                // REMOVE: btnProceed.Enabled = false;
                return;
            }

            var priceMap = ViewState["PriceMap"] as Dictionary<int, decimal> ?? new Dictionary<int, decimal>();
            decimal subtotal = 0;
            var seatLabels = new List<string>();

            foreach (var sid in selectedIds)
            {
                if (int.TryParse(sid, out int seatId) && priceMap.ContainsKey(seatId))
                    subtotal += priceMap[seatId];
                seatLabels.Add("Seat " + sid);
            }

            decimal fee = Math.Round(subtotal * 0.02m);
            decimal discount = decimal.TryParse(hfDiscount.Value, out decimal d) ? d : 0m;
            decimal total = subtotal + fee - discount;

            lblSumSeats.Text = string.Join(", ", seatLabels);
            lblSumSubtotal.Text = subtotal.ToString("N0");
            lblSumFee.Text = fee.ToString("N0");
            lblSumDiscount.Text = discount.ToString("N0");
            lblSumTotal.Text = total.ToString("N0");
            // REMOVE: btnProceed.Enabled = selectedIds.Length > 0;

            ViewState["Subtotal"] = subtotal;
            ViewState["Fee"] = fee;
            ViewState["Total"] = total;
        }

        protected void btnApplyCoupon_Click(object sender, EventArgs e)
        {
            string code = txtCoupon.Text.Trim().ToUpper();
            if (string.IsNullOrEmpty(code)) return;

            decimal subtotal = ViewState["Subtotal"] != null ? (decimal)ViewState["Subtotal"] : 0m;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
                    SELECT CouponId, DiscountType, DiscountValue, MaxDiscount, MinOrderValue
                    FROM   Coupons
                    WHERE  Code       = @code
                      AND  ValidFrom <= GETDATE()
                      AND  ValidTill >= GETDATE()
                      AND  (UsageLimit IS NULL OR UsedCount < UsageLimit)", con);
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
                    RefreshSummary(); return;
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
                    if (maxDisc != DBNull.Value) discount = Math.Min(discount, Convert.ToDecimal(maxDisc));
                }
                else discount = discVal;

                hfCouponId.Value = r["CouponId"].ToString();
                hfDiscount.Value = discount.ToString("F0");

                lblCouponMsg.Text = $"✅ Coupon applied! You save ₹{discount:N0}";
                lblCouponMsg.CssClass = "coupon-msg coupon-ok";
                lblCouponMsg.Visible = true;
            }
            RefreshSummary();
        }

        protected void btnProceed_Click(object sender, EventArgs e)
        {
            // If triggered by seat toggle JS postback, just refresh
            //string arg = Request["__EVENTARGUMENT"];
            //if (arg == "seatchange") { RefreshSummary(); return; }

            string selectedSeats = hfSelected.Value;
            var selectedIds = selectedSeats.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            if (selectedIds.Length == 0) { ShowMessage("Please select at least one seat.", true); return; }

            int userId = GetUserId();
            if (userId == 0) { Response.Redirect("Log.aspx"); return; }

            int id = int.Parse(hfShowId.Value);
            decimal subtotal = ViewState["Subtotal"] != null ? (decimal)ViewState["Subtotal"] : 0m;
            decimal fee = Math.Round(subtotal * 0.02m);
            decimal discount = decimal.TryParse(hfDiscount.Value, out decimal d) ? d : 0m;
            decimal total = subtotal + fee - discount;
            int couponId = int.TryParse(hfCouponId.Value, out int c) ? c : 0;
            string bookingRef = "SB" + DateTime.Now.ToString("yyyyMMddHHmmss") + new Random().Next(10, 99);

            var priceMap = ViewState["PriceMap"] as Dictionary<int, decimal> ?? new Dictionary<int, decimal>();

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlTransaction tx = con.BeginTransaction();
                try
                {
                    // Insert Booking
                    SqlCommand cmdBook = new SqlCommand(@"
                        INSERT INTO Bookings (UserId,ShowId,TotalAmount,DiscountAmount,FinalAmount,CouponId,BookingRef,Status,BookingDate)
                        VALUES (@uid,@sid,@tot,@disc,@fin,@cid,@ref,'Pending',GETDATE());
                        SELECT SCOPE_IDENTITY();", con, tx);
                    cmdBook.Parameters.AddWithValue("@uid", userId);
                    cmdBook.Parameters.AddWithValue("@sid", id);
                    cmdBook.Parameters.AddWithValue("@tot", subtotal);
                    cmdBook.Parameters.AddWithValue("@disc", discount);
                    cmdBook.Parameters.AddWithValue("@fin", total);
                    cmdBook.Parameters.AddWithValue("@cid", couponId > 0 ? (object)couponId : DBNull.Value);
                    cmdBook.Parameters.AddWithValue("@ref", bookingRef);
                    int bookingId = Convert.ToInt32(cmdBook.ExecuteScalar());

                    // Insert BookedSeats
                    foreach (var sid in selectedIds)
                    {
                        if (!int.TryParse(sid, out int seatId)) continue;
                        decimal price = priceMap.ContainsKey(seatId) ? priceMap[seatId] : 0m;

                        SqlCommand cmdSeat = new SqlCommand(@"
                            INSERT INTO BookedSeats (BookingId,SeatId,ShowId,PricePaid,Status,HeldUntil)
                            VALUES (@bid,@seatId,@showId,@price,'Held',DATEADD(MINUTE,10,GETDATE()))", con, tx);
                        cmdSeat.Parameters.AddWithValue("@bid", bookingId);
                        cmdSeat.Parameters.AddWithValue("@seatId", seatId);
                        cmdSeat.Parameters.AddWithValue("@showId", id);
                        cmdSeat.Parameters.AddWithValue("@price", price);
                        cmdSeat.ExecuteNonQuery();
                    }

                    // Increment coupon
                    if (couponId > 0)
                    {
                        new SqlCommand("UPDATE Coupons SET UsedCount=UsedCount+1 WHERE CouponId=@id", con, tx)
                        { Parameters = { new SqlParameter("@id", couponId) } }.ExecuteNonQuery();
                    }

                    tx.Commit();

                    Session["ShowBookingId"] = bookingId;
                    Session["ShowBookingRef"] = bookingRef;
                    Session["ShowSeats"] = string.Join(", ", selectedIds.Select(s => "Seat " + s));
                    Session["ShowTotal"] = total;

                    Response.Redirect("ShowPayment.aspx?BookingId=" + bookingId + "&ref=" + bookingRef);
                }
                catch (Exception ex)
                { 
                    ShowMessage("Booking failed: " + ex.Message, true);
                }
            }
        }

        private int GetUserId()
        {
            string username = Session["Username"].ToString();
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT UserId FROM Users WHERE Username=@u", con);
                cmd.Parameters.AddWithValue("@u", username);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt.Rows.Count > 0 ? Convert.ToInt32(dt.Rows[0]["UserId"]) : 0;
            }
        }

        private string FormatTime(object timeVal)
        {
            if (timeVal == null || timeVal == DBNull.Value) return "";
            if (timeVal is TimeSpan ts) return DateTime.Today.Add(ts).ToString("hh:mm tt");
            if (TimeSpan.TryParse(timeVal.ToString(), out TimeSpan parsed)) return DateTime.Today.Add(parsed).ToString("hh:mm tt");
            return timeVal.ToString();
        }

        private void ShowMessage(string msg, bool isError)
        {
            lblMessage.Text = $"<div class='msg-box msg-error'>{msg}</div>";
            lblMessage.Visible = true;
        }
    }
}