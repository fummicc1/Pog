package dev.fummicc1.pog.android.ui.views

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material.OutlinedButton
import androidx.compose.material.Text
import androidx.compose.material.TextField
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.zIndex
import com.google.android.gms.maps.model.CameraPosition
import com.google.android.gms.maps.model.LatLng
import com.google.maps.android.compose.GoogleMap
import com.google.maps.android.compose.rememberCameraPositionState
import dev.fummicc1.pog.android.ui.theme.PogTheme


@Composable
fun SearchPlaceScreen() {
    val tokyoRegion = LatLng(36.0, 140.0)
    val cameraPositionState = rememberCameraPositionState {
        position = CameraPosition.fromLatLngZoom(tokyoRegion, 10f)
    }
    val searchQuery = remember {
        mutableStateOf("")
    }

    Column {
        Row(modifier = Modifier.padding(all = 8.dp), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            TextField(
                value = searchQuery.value,
                singleLine = true,
                onValueChange = { searchQuery.value = it },
                modifier = Modifier.weight(1f),
                label = { Text("Label") }
            )
            OutlinedButton(onClick = {}, modifier = Modifier.padding()) {
                Text("Search")
            }
        }
        GoogleMap(
            modifier = Modifier
                .fillMaxSize(),
            cameraPositionState = cameraPositionState
        )
    }
}

@Preview(showBackground = true)
@Composable
fun DefaultPreview() {
    PogTheme {
        SearchPlaceScreen()
    }
}