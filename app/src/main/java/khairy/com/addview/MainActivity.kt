package khairy.com.addview

import android.annotation.SuppressLint
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.Gravity
import android.view.ViewGroup.LayoutParams.WRAP_CONTENT
import android.widget.LinearLayout
import android.widget.TextView
import khairy.com.addview.R.id.tvv
import kotlinx.android.synthetic.main.activity_main.*
import kotlinx.android.synthetic.main.next.*


class MainActivity : AppCompatActivity() {

    lateinit var linear: LinearLayout
//    lateinit var tvv: TextView


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
//        tvv = findViewById(R.id.tvv)
//        var name : String? = "mohamed"
//        if (tvv != null)
//        tvv?.text = name
//        var len = txtView!!.text!!.length
//        Log.d("xxxx" , len.toString())
//        addtxtView()

        addnullView()
    }

    fun addnullView(){
        var name : String? = "mohamed"
        if (tvv == null){
            tvv?.text = name
        }else{
        }
    }

//    @SuppressLint("ResourceType") fun addtxtView(){
//        linear = findViewById(R.id.linear)
//        val valueTV = TextView(this)
//        valueTV.id = 5
//        valueTV.text = "khairy mohamed"
////        var layout = LinearLayout.LayoutParams(WRAP_CONTENT , WRAP_CONTENT)
////        layout.gravity = Gravity.CENTER_VERTICAL
//        linear.addView(valueTV)
//
//    }
}
