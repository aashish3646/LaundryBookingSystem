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

@WebFilter({"/admin", "/admin/*", "/vendors", "/services", "/bookings", "/user/*", "/vendor", "/vendor/*"})
public class AuthenticationFilter implements Filter {

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
        boolean allowed = isAllowed(requestUri, contextPath, role);

        if (!allowed) {
            httpResponse.sendRedirect(contextPath + "/login.jsp?error=unauthorized");
            return;
        }

        chain.doFilter(request, response);
    }

    private boolean isAllowed(String requestUri, String contextPath, String role) {
        if (requestUri.equals(contextPath + "/admin")
                || requestUri.equals(contextPath + "/vendors")
                || requestUri.equals(contextPath + "/services")
                || requestUri.startsWith(contextPath + "/admin/")) {
            return "admin".equals(role);
        }
        if (requestUri.equals(contextPath + "/bookings")) {
            return "user".equals(role);
        }
        if (requestUri.startsWith(contextPath + "/user/")) {
            return "user".equals(role);
        }
        if (requestUri.equals(contextPath + "/vendor") || requestUri.startsWith(contextPath + "/vendor/")) {
            return "vendor".equals(role);
        }
        return false;
    }
}
