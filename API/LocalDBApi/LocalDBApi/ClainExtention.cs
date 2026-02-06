using System.Security.Claims;

namespace LocalDBApi
{
    public static class ClainExtention
    {
        public static long GetUserId(this ClaimsPrincipal principal)
        {
            if (principal == null)
                throw new ArgumentNullException(nameof(principal));

            var claim = principal.FindFirst(ClaimTypes.NameIdentifier) ??
                        principal.FindFirst("sub");

            if (claim == null)
                throw new InvalidOperationException("User ID claim not found");

            if (!long.TryParse(claim.Value, out long userId))
                throw new InvalidOperationException("Invalid User ID format");

            return userId;
        }

        public static long? TryGetUserId(this ClaimsPrincipal principal)
        {
            try
            {
                return GetUserId(principal);
            }
            catch
            {
                return null;
            }
            }
        
    }
}
