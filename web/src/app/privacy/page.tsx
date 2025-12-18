import Link from 'next/link';
import { Shield, Lock, Eye, FileText, AlertCircle, CheckCircle } from 'lucide-react';

export default function PrivacyPolicyPage() {
  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-gradient-to-r from-blue-600 to-blue-800 text-white py-12">
        <div className="container mx-auto px-4">
          <div className="max-w-4xl mx-auto text-center">
            <Shield className="w-16 h-16 mx-auto mb-4" />
            <h1 className="text-4xl font-bold mb-4">Chính Sách Bảo Mật</h1>
            <p className="text-xl text-blue-100">
              Cam kết bảo vệ thông tin và quyền riêng tư của khách hàng
            </p>
          </div>
        </div>
      </div>

      {/* Content */}
      <div className="container mx-auto px-4 py-12">
        <div className="max-w-4xl mx-auto">
          <div className="bg-white rounded-lg shadow-md p-8">
            {/* Introduction */}
            <div className="mb-8">
              <p className="text-gray-700 leading-relaxed mb-4">
                Chào mừng bạn đến với <strong>Cần Thủ Shop</strong>. Chúng tôi cam kết bảo vệ quyền riêng tư 
                và thông tin cá nhân của bạn. Chính sách bảo mật này giải thích cách chúng tôi thu thập, 
                sử dụng, và bảo vệ thông tin của bạn khi sử dụng website và dịch vụ của chúng tôi.
              </p>
              <p className="text-sm text-gray-500 italic">
                Cập nhật lần cuối: 18/12/2025
              </p>
            </div>

            {/* Section 1 */}
            <section className="mb-8">
              <div className="flex items-start gap-3 mb-4">
                <FileText className="w-6 h-6 text-blue-600 flex-shrink-0 mt-1" />
                <div>
                  <h2 className="text-2xl font-bold text-gray-900 mb-3">
                    1. Thông Tin Chúng Tôi Thu Thập
                  </h2>
                  <p className="text-gray-700 mb-3">
                    Chúng tôi thu thập các loại thông tin sau:
                  </p>
                  <ul className="space-y-2 text-gray-700">
                    <li className="flex items-start gap-2">
                      <CheckCircle className="w-5 h-5 text-green-500 flex-shrink-0 mt-0.5" />
                      <span><strong>Thông tin cá nhân:</strong> Họ tên, email, số điện thoại, địa chỉ giao hàng</span>
                    </li>
                    <li className="flex items-start gap-2">
                      <CheckCircle className="w-5 h-5 text-green-500 flex-shrink-0 mt-0.5" />
                      <span><strong>Thông tin đơn hàng:</strong> Lịch sử mua hàng, sản phẩm yêu thích, giỏ hàng</span>
                    </li>
                    <li className="flex items-start gap-2">
                      <CheckCircle className="w-5 h-5 text-green-500 flex-shrink-0 mt-0.5" />
                      <span><strong>Thông tin thanh toán:</strong> Phương thức thanh toán (không lưu trữ thông tin thẻ)</span>
                    </li>
                    <li className="flex items-start gap-2">
                      <CheckCircle className="w-5 h-5 text-green-500 flex-shrink-0 mt-0.5" />
                      <span><strong>Thông tin kỹ thuật:</strong> Địa chỉ IP, loại trình duyệt, thời gian truy cập</span>
                    </li>
                  </ul>
                </div>
              </div>
            </section>

            {/* Section 2 */}
            <section className="mb-8">
              <div className="flex items-start gap-3 mb-4">
                <Eye className="w-6 h-6 text-blue-600 flex-shrink-0 mt-1" />
                <div>
                  <h2 className="text-2xl font-bold text-gray-900 mb-3">
                    2. Mục Đích Sử Dụng Thông Tin
                  </h2>
                  <p className="text-gray-700 mb-3">
                    Thông tin của bạn được sử dụng cho các mục đích sau:
                  </p>
                  <ul className="space-y-2 text-gray-700 list-disc list-inside ml-4">
                    <li>Xử lý và giao hàng đơn hàng của bạn</li>
                    <li>Gửi thông báo về trạng thái đơn hàng</li>
                    <li>Cung cấp dịch vụ chăm sóc khách hàng</li>
                    <li>Cải thiện trải nghiệm mua sắm và website</li>
                    <li>Gửi thông tin khuyến mãi, ưu đãi (với sự đồng ý của bạn)</li>
                    <li>Phân tích và nghiên cứu thị trường</li>
                    <li>Ngăn chặn gian lận và bảo vệ an ninh</li>
                  </ul>
                </div>
              </div>
            </section>

            {/* Section 3 */}
            <section className="mb-8">
              <div className="flex items-start gap-3 mb-4">
                <Lock className="w-6 h-6 text-blue-600 flex-shrink-0 mt-1" />
                <div>
                  <h2 className="text-2xl font-bold text-gray-900 mb-3">
                    3. Bảo Mật Thông Tin
                  </h2>
                  <p className="text-gray-700 mb-3">
                    Chúng tôi áp dụng các biện pháp bảo mật nghiêm ngặt:
                  </p>
                  <div className="bg-blue-50 border-l-4 border-blue-500 p-4 mb-3">
                    <p className="text-gray-700">
                      <strong>🔒 Mã hóa SSL:</strong> Tất cả dữ liệu được truyền tải qua kết nối an toàn HTTPS
                    </p>
                  </div>
                  <div className="bg-blue-50 border-l-4 border-blue-500 p-4 mb-3">
                    <p className="text-gray-700">
                      <strong>🔐 Bảo mật cơ sở dữ liệu:</strong> Thông tin được lưu trữ trên server có bảo mật cao
                    </p>
                  </div>
                  <div className="bg-blue-50 border-l-4 border-blue-500 p-4">
                    <p className="text-gray-700">
                      <strong>👥 Kiểm soát truy cập:</strong> Chỉ nhân viên được ủy quyền mới có quyền truy cập
                    </p>
                  </div>
                </div>
              </div>
            </section>

            {/* Section 4 */}
            <section className="mb-8">
              <h2 className="text-2xl font-bold text-gray-900 mb-3">
                4. Chia Sẻ Thông Tin
              </h2>
              <p className="text-gray-700 mb-3">
                Chúng tôi không bán hoặc cho thuê thông tin cá nhân của bạn cho bên thứ ba. 
                Thông tin chỉ được chia sẻ trong các trường hợp:
              </p>
              <ul className="space-y-2 text-gray-700 list-disc list-inside ml-4">
                <li>Với đơn vị vận chuyển để giao hàng</li>
                <li>Với cổng thanh toán để xử lý giao dịch</li>
                <li>Khi có yêu cầu từ cơ quan pháp luật</li>
                <li>Với sự đồng ý rõ ràng của bạn</li>
              </ul>
            </section>

            {/* Section 5 */}
            <section className="mb-8">
              <h2 className="text-2xl font-bold text-gray-900 mb-3">
                5. Quyền Của Bạn
              </h2>
              <p className="text-gray-700 mb-3">
                Bạn có các quyền sau đối với thông tin cá nhân:
              </p>
              <div className="grid md:grid-cols-2 gap-4">
                <div className="border border-gray-200 rounded-lg p-4">
                  <h3 className="font-semibold text-gray-900 mb-2">✅ Quyền truy cập</h3>
                  <p className="text-sm text-gray-600">Yêu cầu xem thông tin chúng tôi lưu trữ về bạn</p>
                </div>
                <div className="border border-gray-200 rounded-lg p-4">
                  <h3 className="font-semibold text-gray-900 mb-2">✏️ Quyền chỉnh sửa</h3>
                  <p className="text-sm text-gray-600">Cập nhật hoặc sửa thông tin không chính xác</p>
                </div>
                <div className="border border-gray-200 rounded-lg p-4">
                  <h3 className="font-semibold text-gray-900 mb-2">🗑️ Quyền xóa</h3>
                  <p className="text-sm text-gray-600">Yêu cầu xóa thông tin cá nhân của bạn</p>
                </div>
                <div className="border border-gray-200 rounded-lg p-4">
                  <h3 className="font-semibold text-gray-900 mb-2">🚫 Quyền từ chối</h3>
                  <p className="text-sm text-gray-600">Từ chối nhận email marketing</p>
                </div>
              </div>
            </section>

            {/* Section 6 */}
            <section className="mb-8">
              <h2 className="text-2xl font-bold text-gray-900 mb-3">
                6. Cookies
              </h2>
              <p className="text-gray-700 mb-3">
                Website sử dụng cookies để cải thiện trải nghiệm người dùng:
              </p>
              <ul className="space-y-2 text-gray-700 list-disc list-inside ml-4">
                <li><strong>Cookies cần thiết:</strong> Đảm bảo website hoạt động bình thường</li>
                <li><strong>Cookies phân tích:</strong> Hiểu cách người dùng tương tác với website</li>
                <li><strong>Cookies tiếp thị:</strong> Hiển thị quảng cáo phù hợp với bạn</li>
              </ul>
              <p className="text-sm text-gray-600 mt-3 italic">
                Bạn có thể quản lý cookies trong cài đặt trình duyệt của mình.
              </p>
            </section>

            {/* Section 7 */}
            <section className="mb-8">
              <h2 className="text-2xl font-bold text-gray-900 mb-3">
                7. Thời Gian Lưu Trữ
              </h2>
              <p className="text-gray-700">
                Chúng tôi lưu trữ thông tin của bạn trong thời gian cần thiết để:
              </p>
              <ul className="space-y-2 text-gray-700 list-disc list-inside ml-4 mt-2">
                <li>Cung cấp dịch vụ cho bạn</li>
                <li>Tuân thủ nghĩa vụ pháp lý</li>
                <li>Giải quyết tranh chấp và thực thi hợp đồng</li>
              </ul>
            </section>

            {/* Contact */}
            <section className="bg-blue-50 rounded-lg p-6">
              <div className="flex items-start gap-3">
                <AlertCircle className="w-6 h-6 text-blue-600 flex-shrink-0 mt-1" />
                <div>
                  <h2 className="text-xl font-bold text-gray-900 mb-3">
                    Liên Hệ Với Chúng Tôi
                  </h2>
                  <p className="text-gray-700 mb-3">
                    Nếu bạn có bất kỳ câu hỏi nào về chính sách bảo mật này, vui lòng liên hệ:
                  </p>
                  <div className="space-y-2 text-gray-700">
                    <p><strong>Email:</strong> privacy@canthushop.vn</p>
                    <p><strong>Điện thoại:</strong> 0123 456 789</p>
                    <p><strong>Địa chỉ:</strong> 123 Đường Nguyễn Văn Linh, Quận 7, TP. HCM</p>
                  </div>
                </div>
              </div>
            </section>

            {/* Back to home */}
            <div className="mt-8 text-center">
              <Link
                href="/"
                className="inline-block bg-blue-600 text-white px-6 py-3 rounded-lg font-semibold hover:bg-blue-700 transition-colors"
              >
                Quay về trang chủ
              </Link>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
