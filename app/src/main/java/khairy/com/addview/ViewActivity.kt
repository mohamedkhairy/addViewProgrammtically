package khairy.com.addview

import android.support.v7.app.AppCompatActivity
import android.os.Bundle

class ViewActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_view)

        var test = testClass("khairy")
        var test1 = testClass("khairy")
        var test2 = testClass("khairy")

    }
}
