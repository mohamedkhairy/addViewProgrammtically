package com.innovolve.iqraaly.data.remote.newbackend

import android.app.Application
import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkInfo
import android.util.Log
import com.innovolve.iqraaly.BuildConfig
import com.innovolve.iqraaly.base.app.IqraalyApplication
import com.innovolve.iqraaly.base.isNotNull
import com.innovolve.iqraaly.managers.UserManager
import com.innovolve.iqraaly.model.*
import com.jakewharton.retrofit2.adapter.kotlin.coroutines.experimental.CoroutineCallAdapterFactory
import kotlinx.coroutines.experimental.Deferred
import okhttp3.Interceptor
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.*
import java.io.IOException
import java.util.concurrent.TimeUnit

object NewIqraalyWebClient {

    private const val BASE_URL = "https://app.iqraaly.com/api/"
    private const val TIMEOUT_SEC = 30L
    private val app: Application = IqraalyApplication.app

    private val bearerToken: () -> String =
        { UserManager.getUserManager(app).accessToken.toBearerToken() }

    private val loggingInterceptor: () -> HttpLoggingInterceptor =
        { HttpLoggingInterceptor().setLevel(HttpLoggingInterceptor.Level.BODY) }

    private val connectivityInterceptor: () -> Interceptor = { app.connectivityInterceptor() }

    private val endPoints: () -> EndPoints = { retrofit().create(EndPoints::class.java) }

    private val retrofit: () -> Retrofit =
        { httpClient().build().getRetrofitBuilder(BASE_URL).build() }

    private fun String.toBearerToken(): String =
        "Bearer ${this}"

    private fun Retrofit.Builder.addCoroutinesAdapter(): Retrofit.Builder =
        addCallAdapterFactory(CoroutineCallAdapterFactory())

    private fun OkHttpClient.Builder.addLoggingInterceptorDevOnly(): OkHttpClient.Builder =
        if (isDev()) addInterceptor(loggingInterceptor())
        else this

    private fun OkHttpClient.Builder.addConnectivityInterceptor(): OkHttpClient.Builder =
        addInterceptor(connectivityInterceptor())

    private fun httpClient(): OkHttpClient.Builder =
        {
            OkHttpClient.Builder().addBearerTokenInterceptor().addLoggingInterceptorDevOnly()
                .addConnectivityInterceptor()
                .setTimeout(TIMEOUT_SEC)
        }()

    private fun bearerTokenInterceptor(): Interceptor =
        Interceptor { chain ->
            chain.proceed(
                chain.request().newBuilder().addHeader(
                    "Authorization",
                    bearerToken()
                ).build()
            )
        }

    private fun OkHttpClient.Builder.addBearerTokenInterceptor(): OkHttpClient.Builder =
        addInterceptor(bearerTokenInterceptor())

    private fun Retrofit.Builder.addGsonFactory(): Retrofit.Builder =
        addConverterFactory(GsonConverterFactory.create())

    private fun OkHttpClient.getRetrofitBuilder(baseUrl: String): Retrofit.Builder =
        Retrofit.Builder().baseUrl(baseUrl).client(this).addGsonFactory().addCoroutinesAdapter()

    private fun OkHttpClient.Builder.setTimeout(timeoutInSec: Long): OkHttpClient.Builder =
        {
            this.connectTimeout(timeoutInSec, TimeUnit.SECONDS)
                .readTimeout(timeoutInSec, TimeUnit.SECONDS)
                .writeTimeout(timeoutInSec, TimeUnit.SECONDS)
        }()

    private fun isDev(): Boolean =
        BuildConfig.VERSION_NAME.contains("dev", true)

    private fun Application.connectivityInterceptor(): Interceptor {
        return Interceptor { chain: Interceptor.Chain ->
            if (isNotInternetConnected()) throw NoInternetException()
            return@Interceptor chain.proceed(chain.request().newBuilder().build())
        }
    }


    private fun Application.isInternetConnected(): Boolean {
        val connMgr: ConnectivityManager =
            getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val networkInfo: NetworkInfo? = connMgr.activeNetworkInfo
        return networkInfo.isNotNull() && networkInfo!!.isConnected
    }

    private fun Application.isNotInternetConnected(): Boolean =
        !isInternetConnected()

    private interface EndPoints {

        @GET("android/pages/subscriptions/{offer_id}")
        fun getPlans(@Path("offer_id") offerId: String): Deferred<PlansResponse?>

        @POST("android/fcmtoken/register")
        @FormUrlEncoded
        fun registerFCMToken(
            @Field("token")
            fcmToken: String
        ): Deferred<RegisterFCMResponse?>

        @GET("messages")
        fun getMessagesList(@Query("page") pageNumber: Int): Deferred<MessagesListResponse?>

        @GET("home")
        fun getHomeMessages(): Deferred<HomeMessage?>

        @GET("book/{book_id}")
        fun getBookInfo(@Path("book_id") bookId: String): Deferred<BookInfoResponse?>

        @GET("account/anonymous/create")
        fun skipRegistration(): Deferred<SkipRegistrationResponse?>

        @POST("books/review/create")
        @FormUrlEncoded
        fun rateBook(
            @Field("show_id") bookId: Int, @Field("rating[1]")
            bookRate: Int, @Field("rating[2]") narratorRate: Int
        ): Deferred<RateBookResponse?>
