package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Logger;
import java.util.logging.Level;

@WebFilter({"/admin", "/admin/*", "/vendors", "/services", "/bookings", "/user/*", "/vendor", "/vendor/*"})
public class AuthenticationFilter implements Filter {
    private static final Logger LOGGER = Logger.getLogger(AuthenticationFilter.class.getName());

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String contextPath = httpRequest.getContextPath();
        String requestUri = httpRequest.getRequestURI();

        if (session == null || session.getAttribute("userRole") == null) {
            httpResponse.sendRedirect(contextPath + "/login.jsp?error=login_required");
            return;
        }

        String role = (String) session.getAttribute("userRole");
        boolean allowed = isAllowed(httpRequest, requestUri, contextPath, role);

        if (!allowed) {
            LOGGER.info("AUTH FILTER: Access DENIED for URI " + requestUri + " and Role " + role);
            httpResponse.sendRedirect(contextPath + "/login.jsp?error=unauthorized");
            return;
        }

        LOGGER.info("AUTH FILTER: Access GRANTED for URI " + requestUri + " and Role " + role);
        chain.doFilter(request, response);
    }

    private boolean isAllowed(HttpServletRequest httpRequest, String requestUri, String contextPath, String role) {
        // Normalize URI by removing trailing slash if present (except for root context)
        String path = requestUri.substring(contextPath.length());
        if (path.length() > 1 && path.endsWith("/")) {
            path = path.substring(0, path.length() - 1);
        }

        // Admin paths
        if (path.equals("/admin") || path.startsWith("/admin/") || path.equals("/services")) {
            return "admin".equals(role);
        }

        // Vendors path (admin only, except for ajax-search which users need)
        if (path.equals("/vendors")) {
            String action = httpRequest.getParameter("action");
            if ("ajax-search".equals(action)) {
                return "user".equals(role) || "admin".equals(role);
            }
            return "admin".equals(role);
        }

        // User paths
        if (path.equals("/bookings") || path.startsWith("/user/")) {
            return "user".equals(role);
        }

        // Vendor paths
        if (path.equals("/vendor") || path.startsWith("/vendor/")) {
            return "vendor".equals(role);
        }

        return false;
    }
}
