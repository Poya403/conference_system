namespace LocalDBApi.Enums
{
    public enum PaymentStatusEnum
    {
        None = 0,
        InBasket = 1,
        Registered = 2,
        InWaiting = 3,
        Cancelled = 4
    }
    public static class PaymentStatusEnumExtensions
    {
        public static string ToText(this PaymentStatusEnum status) => status switch
        {
            PaymentStatusEnum.Registered => "ثبت نام شده",
            PaymentStatusEnum.InBasket => "در انتظار پرداخت",
            PaymentStatusEnum.InWaiting => "در لیست انتظار شما",
            PaymentStatusEnum.Cancelled => "کنسل شده",
            _ => "نامشخص"
        };
    }
}



