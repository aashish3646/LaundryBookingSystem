package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        // Allow access to public resources
        if (path.startsWith("/css/") || path.startsWith("/js/") || path.startsWith("/images/") ||
            path.equals("/login.jsp") || path.equals("/register.jsp") || path.equals("/login") ||
            path.equals("/register") || path.equals("/") || path.equals("/index.jsp")) {
            chain.doFilter(request, response);
            return;
        }

        boolean loggedIn = (session != null && session.getAttribute("loggedInUser") != null);
        String userRole = (session != null) ? (String) session.getAttribute("userRole") : null;

        if (!loggedIn) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
            return;
        }

        // Role-based access control
        if (path.startsWith("/admin/") && !"admin".equalsIgnoreCase(userRole)) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admin only.");
            return;
        }

        if (path.startsWith("/vendor/") && !"vendor".equalsIgnoreCase(userRole)) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Vendor only.");
            return;
        }

        if (path.startsWith("/user/") && !"user".equalsIgnoreCase(userRole)) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Customer only.");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
