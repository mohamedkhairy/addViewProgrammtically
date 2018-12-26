package com.innovolve.iqraaly.home.registrationCode


import android.annotation.SuppressLint
import android.app.Application
import android.content.Intent
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import androidx.lifecycle.*
import arrow.core.*
import com.innovolve.iqraaly.R
import com.innovolve.iqraaly.analytics.remote.EventLogger
import com.innovolve.iqraaly.base.Result
import com.innovolve.iqraaly.base.callAPI
import com.innovolve.iqraaly.base.notify
import com.innovolve.iqraaly.customviews.IqraalyProgressDialog
import com.innovolve.iqraaly.data.remote.newbackend.NewIqraalyWebClient
import com.innovolve.iqraaly.interfaces.FinishParent
import com.innovolve.iqraaly.main.activities.MainActivity
import com.innovolve.iqraaly.model.RegistrationCodeResponse
import com.jakewharton.rxbinding2.widget.RxTextView
import io.reactivex.disposables.CompositeDisposable
import kotlinx.android.synthetic.main.fragment_registration_code.*
import kotlinx.coroutines.experimental.Job
import kotlinx.coroutines.experimental.launch
import com.facebook.FacebookSdk.getApplicationContext



class RegistrationCodeFragment : Fragment(), Observer<Pair<String, Boolean>> {

    private val afterMsgS:String by lazy { arguments?.getString("afterMsg","")?:"" }
    private val preMsgS:String by lazy { arguments?.getString("preMsg","")?:"" }

    override fun onChanged(result: Pair<String, Boolean>) {
        notify(
            result.first,
            if (result.second) R.color.green else R.color.color_app_orange_pumpkin
        )
        (activity as? MainActivity)?.let {
            EventLogger.getInstance(this@RegistrationCodeFragment.activity).logRegistrationCodeSent()
            it.updatePurchases()
//            it.onBackPressed()


//            val intent = Intent(activity, MainActivity::class.java)
//            startActivity(intent)

            val myIntent = Intent(it, MainActivity::class.java)
            myIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            myIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
            startAct